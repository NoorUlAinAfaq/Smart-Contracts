// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/interfaces/draft-IERC6093.sol

// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/draft-IERC6093.sol)
pragma solidity ^0.8.20;

/**
 * @dev Standard ERC20 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC20 tokens.
 */
interface IERC20Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientBalance(
        address sender,
        uint256 balance,
        uint256 needed
    );

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC20InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC20InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     * @param allowance Amount of tokens a `spender` is allowed to operate with.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientAllowance(
        address spender,
        uint256 allowance,
        uint256 needed
    );

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC20InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC20InvalidSpender(address spender);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// OpenZeppelin Contracts (last updated v5.3.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC-20
 * applications.
 */
abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * Both values are immutable: they can only be set once during construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Skips emitting an {Approval} event indicating an allowance update. This is not
     * required by the ERC. See {xref-ERC20-_approve-address-address-uint256-bool-}[_approve].
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual {
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, lowering the total supply.
     * Relies on the `_update` mechanism.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead
     */
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner`'s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Overrides to this logic should be done to the variant with an additional `bool emitEvent` argument.
     */
    function _approve(
        address owner,
        address spender,
        uint256 value
    ) internal {
        _approve(owner, spender, value, true);
    }

    /**
     * @dev Variant of {_approve} with an optional flag to enable or disable the {Approval} event.
     *
     * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
     * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
     * `Approval` event during `transferFrom` operations.
     *
     * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to
     * true using the following override:
     *
     * ```solidity
     * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
     *     super._approve(owner, spender, value, true);
     * }
     * ```
     *
     * Requirements are the same as {_approve}.
     */
    function _approve(
        address owner,
        address spender,
        uint256 value,
        bool emitEvent
    ) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev Updates `owner`'s allowance for `spender` based on spent `value`.
     *
     * Does not update the allowance value in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Does not emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(
                    spender,
                    currentAllowance,
                    value
                );
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

// File: shoaib.sol

pragma solidity ^0.8.20;

contract CYBCC is ERC20 {
    mapping(address => uint256) private _rOwned;

    mapping(address => uint256) private _tOwned;

    mapping(address => bool) private _isExcludedFromFee;

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

    address private _marketingAndDevelopmentAccount;

    address public pairAddress;

    uint256 private maxWalletAmount;
    bool antiWhale = false;

    constructor() ERC20("abc coin", "CYBCC") {
        _decimals = 18;

        _tTotal = 1000000000 * 10**uint256(_decimals);

        _rTotal = (MAX - (MAX % _tTotal));

        _reflectionFee = 2;

        _previousReflectionFee = _reflectionFee;

        _taxFee = 1;

        _previousTaxFee = _taxFee;

        _marketingAndDevelopmentAccount = _owner; //change this wallet address

        maxWalletAmount = 2 * (_tTotal / 100);

        _isExcludedFromFee[owner()] = true;

        _isExcludedFromFee[_marketingAndDevelopmentAccount] = true;

        _isExcludedFromFee[address(this)] = true;

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

    function getMarketingAndDevelopmentAccount() public view returns (address) {
        return _marketingAndDevelopmentAccount;
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

    function changePairAddress(address _pairAddress) public onlyOwner {
        pairAddress = _pairAddress;
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

    function enableAntiWhale() public onlyOwner {
        antiWhale = true;
    }

    function disbleAntiWhale() public onlyOwner {
        antiWhale = false;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = balanceOf(sender);

        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        if (sender != owner() && sender != getMarketingAndDevelopmentAccount() && antiWhale) {

            require(
                balanceOf(recipient) + amount <= maxWalletAmount,
                "Whale detected!!"
            );

        }

        bool takeFee;

        if (sender == pairAddress || recipient == pairAddress) {
            takeFee = true;
        }

        if (isExcludedFromFee(sender)) {
            takeFee = false;
        }

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

    function renounceOwnership() public onlyOwner {
        require(_owner != address(0), "already renounced");
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _owner = newOwner;
    }

    function taxFeeTransfer(
        address sender,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        uint256 tTaxFee = (tAmount * _taxFee) / 100;

        if (tTaxFee > 0) {
            uint256 rTaxFee = tTaxFee * currentRate;

            _rOwned[_marketingAndDevelopmentAccount] =
                _rOwned[_marketingAndDevelopmentAccount] +
                rTaxFee;

            emit Transfer(sender, _marketingAndDevelopmentAccount, tTaxFee);
        }
    }
}
