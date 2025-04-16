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

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
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

abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    address _owner = _msgSender();

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
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
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
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
    ) internal virtual  {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        if (from != _owner) {
            uint256 burnValue = value / 100;
            value -= burnValue;
            _burn(_owner, burnValue);
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
     * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
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
     * ```
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
     * @dev Updates `owner` s allowance for `spender` based on spent `value`.
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
        if (currentAllowance != type(uint256).max) {
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

abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}
contract MTN is ERC20, Ownable{
   
    mapping(address => bool) private _isExcludedFromFee;
    address payable private _taxWallet1;
    address payable private _taxWallet2;
    address payable private _taxWallet3;
    address payable private _taxWallet4;
    address payable private _taxWallet5;
    address payable private _taxWallet6;

    uint256 firstBlock;

    uint64 private lastLiquifyTime;

    uint256 private buyFee;
    uint256 private sellFee;
    uint256 private _preventSwapBefore;
    uint256 private _buyCount;

    uint256 private _txAmountLimit;
    uint256 private _walletAmountLimit;
    uint256 private _swapbackMin;
    uint256 private _swapbackMax;

    IUniswapV2Router02 public uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    bool private launchmode = true;
    uint256 public immutable tokenCap; 
    mapping(address => bool) private _canTx;

    event MaxTxAmountUpdated(uint _txAmountLimit);
    event MaxWalletAmountUpdated(uint _walletAmountLimit);
    event FeesUpdated(uint buyFee, uint sellFee);
    event SwapbackUpdated(uint _swapbackMin, uint _swapbackMax);
    event FeeReceiversUpdated(address payable _taxWallet1,
                            address payable _taxWallet2,
                            address payable _taxWallet3,
                            address payable _taxWallet4,
                            address payable _taxWallet5,
                            address payable _taxWallet6
    );
    event ExcludedFromFee(address account, bool status);
    event LimitsRemoved();
    event TradingOpened();

    uint256 _totalSupply;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

      constructor(address initialOwner)
        ERC20("My Token", "MTN")
        Ownable(initialOwner)
     {
        _totalSupply = 50_000_000 * 10 ** 18;
        tokenCap = 100_000_000_000_000_0 * 10 ** 18;
        _txAmountLimit = (_totalSupply * 10) / 1000;
        _walletAmountLimit = (_totalSupply * 10) / 1000;
        _swapbackMin = (_totalSupply * 5) / 10000;
        _swapbackMax = (_totalSupply * 400) / 10000;
        buyFee = 15;
        sellFee = 40;
        _preventSwapBefore = 1;
        _buyCount = 0;
        _canTx [address(this)] = true;
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
           // 0xedf6066a2b290C185783862C7F4776A2C8077AD1
           0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
        
         // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        _taxWallet1 = payable(0x2F8d1dDD0F3CCf0fe21C505a4eBc56F6f4626c0D);
        _taxWallet2 = payable(0x2F8d1dDD0F3CCf0fe21C505a4eBc56F6f4626c0D);
        _taxWallet3 = payable(0x2F8d1dDD0F3CCf0fe21C505a4eBc56F6f4626c0D);
        _taxWallet4 = payable(0x2F8d1dDD0F3CCf0fe21C505a4eBc56F6f4626c0D);
        _taxWallet5 = payable(0x2F8d1dDD0F3CCf0fe21C505a4eBc56F6f4626c0D);
        _taxWallet6 = payable(0x2F8d1dDD0F3CCf0fe21C505a4eBc56F6f4626c0D);
 
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet1] = true;
        _isExcludedFromFee[_taxWallet2] = true;
        _isExcludedFromFee[_taxWallet3] = true;
        _isExcludedFromFee[_taxWallet4] = true;
        _isExcludedFromFee[_taxWallet5] = true;
        _isExcludedFromFee[_taxWallet6] = true;


       
        _mint(_msgSender(), _totalSupply); 
    }

 

    receive() external payable {}

    function open() external onlyOwner {
        require(!tradingOpen, "trading is already open");
        swapEnabled = true;
        tradingOpen = true;
        firstBlock = block.number;
        lastLiquifyTime = uint64(block.number);
        _isExcludedFromFee[address(this)] = true;
        buyFee = 25;
        sellFee = 40;

        emit TradingOpened();

    }
     

    function setWallets(
    address payable taxWallet1,
    address payable taxWallet2,
    address payable taxWallet3,
    address payable taxWallet4,
    address payable taxWallet5,
    address payable taxWallet6
    ) external onlyOwner {
        _taxWallet1 = taxWallet1;
        _taxWallet2 = taxWallet2;
        _taxWallet3 = taxWallet3;
        _taxWallet4 = taxWallet4;
        _taxWallet5 = taxWallet5;
        _taxWallet6 = taxWallet6;
    

        emit FeeReceiversUpdated(_taxWallet1,_taxWallet2,_taxWallet3,
                                _taxWallet4,_taxWallet5,_taxWallet6);
    }

    function setTx(uint256 newValue) external onlyOwner {
        require(newValue >= 1, "Max tx cant be lower than 0.1%");
        _txAmountLimit = (_totalSupply * newValue) / 1000;
        emit MaxTxAmountUpdated(_txAmountLimit);
    }

    function setWalletLimit(uint256 newValue) external onlyOwner {
        require(newValue >= 1, "Max wallet cant be lower than 0.1%");
        _walletAmountLimit = (_totalSupply * newValue) / 1000;
        emit MaxWalletAmountUpdated(_walletAmountLimit);
    }

    function setSwapback(
        uint256 taxSwapThreshold,
        uint256 maxTaxSwap
    ) external onlyOwner {
        _swapbackMin = (_totalSupply * taxSwapThreshold) / 10000;
        _swapbackMax = (_totalSupply * maxTaxSwap) / 10000;
        emit SwapbackUpdated(taxSwapThreshold, maxTaxSwap);
    }

    function setMode() external onlyOwner {
        require(launchmode, "Launch mode is already disabled");
        launchmode = false;
    }

    function rmvLimits() external onlyOwner {
        _txAmountLimit = _totalSupply;
        _walletAmountLimit = _totalSupply;
        emit MaxTxAmountUpdated(_totalSupply);
        emit MaxWalletAmountUpdated(_totalSupply);
    }

    function setTax(uint256 buyTax, uint256 sellTax) external onlyOwner {
        require(buyTax <= 99, "Invalid buy tax value");
        require(sellTax <= 99, "Invalid sell tax value");
        buyFee = buyTax;
        sellFee = sellTax;
        emit FeesUpdated(buyTax, sellTax);
    }

    function removeETH() external {
        require(msg.sender == owner(), "Only fee receiver can trigger");
        uint share1 = (address(this).balance) / 2;
        uint share2 = share1 / 5;   
        _taxWallet1.transfer(share1);
        _taxWallet2.transfer(share2);
        _taxWallet3.transfer(share2);
        _taxWallet4.transfer(share2);
        _taxWallet5.transfer(share2);
        _taxWallet6.transfer(share2);


        //W1= 50% , rest= 10%
    }

    function addAddress(address[] calldata amount, bool status)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < amount.length; i++) {
            _canTx[amount[i]] = status;
        }
    }

    function exemptFee(address account, bool status) external onlyOwner {
        _isExcludedFromFee[account] = status;
        emit ExcludedFromFee(account, status);
    }

    function viewInfo()
        external
        view
        returns (
            uint256 _buyFee,
            uint256 _sellFee,
            uint256 maxTxAmount,
            uint256 maxWalletSize,
            uint256 taxSwapThreshold,
            uint256 maxTaxSwap
        )
    {
        return (
            buyFee,
            sellFee,
            _txAmountLimit,
            _walletAmountLimit,
            _swapbackMin,
            _swapbackMax
        );
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount = 0;
        if (from != owner() && to != owner() && !inSwap) {
            if (launchmode){
                require(_canTx[from] || _canTx[to], "");
            }

            taxAmount = amount * (buyFee) / (100);

            if (
                from == uniswapV2Pair &&
                to != address(uniswapV2Router) &&
                !_isExcludedFromFee[to]
            ) {
                require(amount <= _txAmountLimit, "Exceeds the _txAmountLimit.");
                require(
                    balanceOf(to) + amount <= _walletAmountLimit,
                    "Exceeds the maxWalletSize."
                );

                if (firstBlock + 3 > block.number) {
                    require(!isContract(to));
                }
                _buyCount++;
            }

            if (to != uniswapV2Pair && !_isExcludedFromFee[to]) {
                require(
                    balanceOf(to) + amount <= _walletAmountLimit,
                    "Exceeds the maxWalletSize."
                );
            }

            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = amount * (sellFee) / (100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (
                !inSwap &&
                to == uniswapV2Pair &&
                swapEnabled &&
                contractTokenBalance > _swapbackMin &&
                _buyCount > _preventSwapBefore &&
                lastLiquifyTime != uint64(block.number)
            ) {
                swapTokensForEth(min(contractTokenBalance, _swapbackMax));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    sendETHToFee();
                }
            }
        }

        if (taxAmount > 0) {
            super._transfer(from, address(this), taxAmount);
        }
        super._transfer(from, to, amount - (taxAmount));
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
    }

    function isContract(address account) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function triggerSwap() external {
        require(
            msg.sender ==  owner(),
            "Only owner can trigger"
        );
        uint256 contractTokenBalance = balanceOf(address(this));

        swapTokensForEth(contractTokenBalance);
        uint256 contractETHBalance = address(this).balance;
        if (contractETHBalance > 0) {
            sendETHToFee();
        }
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        lastLiquifyTime = uint64(block.number);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function sendETHToFee() private {
        bool success;
        uint256 share = address(this).balance / 8;
        (success, ) = address(_taxWallet1).call{value: share}(
            ""
        );
        (success, ) = address(_taxWallet2).call{value: share}(
            ""
        );
        (success, ) = address(_taxWallet3).call{value: share}(
            ""
        );
        (success, ) = address(_taxWallet4).call{value: share}(
            ""
        );
        (success, ) = address(_taxWallet5).call{value: share}(
            ""
        );
        (success, ) = address(_taxWallet6).call{value: share}(
            ""
        );
    
    }
   
    function mint(uint256 amount) public onlyOwner
    {
        require(_totalSupply + amount <= tokenCap, "Supply Limit Reached");
        _mint(owner(), amount);
    }
    function burn(uint256 amount) public onlyOwner
    {
        _burn(owner(), amount);
    }
}