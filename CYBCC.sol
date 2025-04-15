// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CYBCC is ERC20 {
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) public isWhitelisted;

    mapping(address => bool) private _isExcluded;
    address[] private _excluded;

    uint8 private _decimals;
    address private _owner = msg.sender;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _tFeeTotal = 0;

    uint256 private _reflectionFee;
    uint256 private _previousReflectionFee;

    uint256 private _taxFee;
    uint256 private _previousTaxFee;

    address private _marketingAccount;
    address private _developmentAccount;

    address public pairAddress;

    uint256 private maxWalletAmount;

    uint256 public launchBlock;
    bool public tradingOpen = false;

    constructor() ERC20("CYBERCATSCOIN", "CYBCC") {
        _decimals = 18;
        _tTotal = 1000000000 * 10**uint256(_decimals);
        _rTotal = (MAX - (MAX % _tTotal));

        _reflectionFee = 2;
        _previousReflectionFee = _reflectionFee;

        _taxFee = 2;
        _previousTaxFee = _taxFee;

        _marketingAccount = _owner;
        _developmentAccount = _owner;

        maxWalletAmount = 10000000 * 10**uint256(_decimals);

        //exclude owner, feeaccount and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[_marketingAccount] = true;
        _isExcludedFromFee[_developmentAccount] = true;
        _isExcludedFromFee[address(this)] = true;
        isWhitelisted[owner()] = true;
        isWhitelisted[_marketingAccount] = true;
        isWhitelisted[_developmentAccount] = true;
        _rOwned[_owner] = _rTotal;
        _mint(msg.sender, _rTotal);
    }

    receive() external payable {}

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        if (owner() == msg.sender) _;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _tTotal;
    }

    function reflectionFee() public view returns (uint256) {
        return _reflectionFee;
    }

    function getTaxFee() public view returns (uint256) {
        return _taxFee;
    }

    function getMarketingAccount() public view returns (address) {
        return _marketingAccount;
    }

    function getDevelopmentAccount() public view returns (address) {
        return _developmentAccount;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function balanceOf(address sender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        if (_isExcluded[sender]) {
            return _tOwned[sender];
        }
        return tokenFromReflection(_rOwned[sender]);
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFeesRedistributed() public view returns (uint256) {
        return _tFeeTotal;
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function changeMarketingAccount(address newFeeAccount) public onlyOwner {
        require(
            newFeeAccount != address(0),
            "zero address can not be the FeeAccount"
        );
        _marketingAccount = newFeeAccount;
    }

    function changeDevelopmentAccount(address newFeeAccount) public onlyOwner {
        require(
            newFeeAccount != address(0),
            "zero address can not be the FeeAccount"
        );
        _developmentAccount = newFeeAccount;
    }

    function changePairAddress(address _pairAddress) public onlyOwner {
        pairAddress = _pairAddress;
        isWhitelisted[pairAddress] = true;
    }

    function reflect(uint256 tAmount) public {
        address sender = _msgSender();
        require(
            !_isExcluded[sender],
            "Excluded addresses cannot call this function"
        );
        (uint256 rAmount, , , ) = _getTransferValues(tAmount);
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _rTotal = _rTotal - rAmount;
        _tFeeTotal = _tFeeTotal + tAmount;
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
        public
        view
        returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount, , , ) = _getTransferValues(tAmount);
            return rAmount;
        } else {
            (, uint256 rTransferAmount, , ) = _getTransferValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount)
        private
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function excludeAccountFromReward(address account) public onlyOwner {
        require(!_isExcluded[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccountinReward(address account) public onlyOwner {
        require(_isExcluded[account], "Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function isWhitelistedAddress(address account) public view returns (bool) {
        return isWhitelisted[account];
    }

    function whitelistedAddress(address account) public onlyOwner {
        require(!isWhitelisted[account], "Address is already whitelisted");
        isWhitelisted[account] = true;
    }

    function openTrading() external onlyOwner {
        tradingOpen = true;
        launchBlock = block.number;
    }

    modifier launchProtection(address from, address to) {
        if (!tradingOpen) {
            require(isWhitelisted[from], "Trading not yet enabled");
        } else if (block.number <= launchBlock + 3) {
            // Allow only whitelisted addresses for 3 blocks
            require(isWhitelisted[to], "Launch protection: not whitelisted");
        }
        _;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override launchProtection(sender, recipient) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 senderBalance = balanceOf(sender);
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        if (!isExcludedFromFee(recipient)) {
            require(
                balanceOf(recipient) + amount <= maxWalletAmount,
                "Whale detected!!"
            );
        }
        bool takeFee;

        if (sender == pairAddress || recipient == pairAddress) {
            takeFee = true;
        }

        if(isExcludedFromFee(sender)){takeFee = false;}

        _tokenTransfer(sender, recipient, amount, takeFee);
    }

    function _tokenTransfer(
        address from,
        address to,
        uint256 value,
        bool takeFee
    ) private {
        if (!takeFee) {
            removeAllFee();
        }

        if (_isExcluded[from] && !_isExcluded[to]) {
            _transferFromExcluded(from, to, value);
        } else if (!_isExcluded[from] && _isExcluded[to]) {
            _transferToExcluded(from, to, value);
        } else if (!_isExcluded[from] && !_isExcluded[to]) {
            _transferStandard(from, to, value);
        } else if (_isExcluded[from] && _isExcluded[to]) {
            _transferBothExcluded(from, to, value);
        } else {
            _transferStandard(from, to, value);
        }

        if (!takeFee) {
            restoreAllFee();
        }
    }

    function removeAllFee() private {
        if (_reflectionFee == 0 && _taxFee == 0) return;

        _previousReflectionFee = _reflectionFee;
        _previousTaxFee = _taxFee;

        _reflectionFee = 0;
        _taxFee = 0;
    }

    function restoreAllFee() private {
        _reflectionFee = _previousReflectionFee;
        _taxFee = _previousTaxFee;
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 currentRate
        ) = _getTransferValues(tAmount);

        _rOwned[sender] = _rOwned[sender] - rAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        taxFeeTransfer(sender, tAmount, currentRate);
        _reflectFee(tAmount, currentRate);

        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 currentRate
        ) = _getTransferValues(tAmount);
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        taxFeeTransfer(sender, tAmount, currentRate);
        _reflectFee(tAmount, currentRate);

        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 currentRate
        ) = _getTransferValues(tAmount);
        _tOwned[sender] = _tOwned[sender] - tAmount;
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        taxFeeTransfer(sender, tAmount, currentRate);
        _reflectFee(tAmount, currentRate);

        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tTransferAmount,
            uint256 currentRate
        ) = _getTransferValues(tAmount);
        _tOwned[sender] = _tOwned[sender] - tAmount;
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        taxFeeTransfer(sender, tAmount, currentRate);
        _reflectFee(tAmount, currentRate);

        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _getCompleteTaxValue(uint256 tAmount)
        private
        view
        returns (uint256)
    {
        uint256 allTaxes = _reflectionFee + _taxFee;
        uint256 taxValue = (tAmount * allTaxes) / 100;
        return taxValue;
    }

    function _getTransferValues(uint256 tAmount)
        private
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 taxValue = _getCompleteTaxValue(tAmount);
        uint256 tTransferAmount = tAmount - taxValue;
        uint256 currentRate = _getRate();
        uint256 rTransferAmount = tTransferAmount * currentRate;
        uint256 rAmount = tAmount * currentRate;
        return (rAmount, rTransferAmount, tTransferAmount, currentRate);
    }

    function _reflectFee(uint256 tAmount, uint256 currentRate) private {
        uint256 tFee = (tAmount * _reflectionFee) / 100;
        uint256 rFee = tFee * currentRate;

        _rTotal = _rTotal - rFee;
        _tFeeTotal = _tFeeTotal + tFee;
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;

        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) {
                return (_rTotal, _tTotal);
            }
            rSupply = rSupply - _rOwned[_excluded[i]];
            tSupply = tSupply - _tOwned[_excluded[i]];
        }

        if (rSupply < _rTotal / _tTotal) {
            return (_rTotal, _tTotal);
        }

        return (rSupply, tSupply);
    }

    function taxFeeTransfer(
        address sender,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        uint256 tTaxFee = (tAmount * _taxFee) / 100;
        if (tTaxFee > 0) {
            uint256 rTaxFee = (tTaxFee * currentRate) / 2;
            _rOwned[_marketingAccount] = _rOwned[_marketingAccount] + rTaxFee;
            _rOwned[_developmentAccount] =
                _rOwned[_developmentAccount] +
                rTaxFee;
            emit Transfer(sender, _marketingAccount, tTaxFee);
            emit Transfer(sender, _developmentAccount, tTaxFee);
        }
    }
}
