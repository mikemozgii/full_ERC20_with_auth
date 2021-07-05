// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './SafeMath.sol';
import './IBEP20.sol';
import './Context.sol';
import './Ownable.sol';
import './Pausable.sol';


contract BEP20 is Context, IBEP20, Ownable, Pausable {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;


  string private _name;
  string private _symbol; 
  uint8 private _decimals;
  uint256 private _totalSupply;

 constructor (string memory name_, string memory symbol_, uint8  decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = 0;
    }

 
  function getOwner() public view  override returns (address) {
    return owner();
  }

 
  function decimals() public view override  returns (uint8) {
    return _decimals;
  }

 
  function symbol() public view override  returns (string memory) {
    return _symbol;
  }


  function name() public view virtual override returns (string memory) {
    return _name;
  }

 
  function totalSupply() public view override  returns (uint256) {
    return _totalSupply;
  }


 
  function balanceOf(address account) public view override  returns (uint256) {
    return _balances[account];
  }
 
  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  
  function allowance(address owner, address spender) public view override  returns (uint256) {
    return _allowances[owner][spender];
  }

 
  function approve(address spender, uint256 amount) public override  returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }


  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    _transfer(sender, recipient, amount);

    uint256 currentAllowance = _allowances[sender][_msgSender()];
    _approve(sender, _msgSender(), currentAllowance.sub(amount, "BEP20: transfer amount exceeds allowance"));
    return true;
  }


event MultiTransfer(uint256 total, address tokenAddress);

    function multiTransfer(address[] memory _accounts, uint256[] memory _amounts) public {
            uint256 total = 0;
            uint8 i = 0;
            for (i; i < _accounts.length; i++) {
                transfer(_accounts[i], _amounts[i]);
                total += _amounts[i];
            }
            emit MultiTransfer(total, _msgSender());

    }

  function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

 
  function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
    uint256 currentAllowance = _allowances[_msgSender()][spender];
    _approve(_msgSender(), spender, currentAllowance.sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }

 

  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

   _beforeTokenAction(owner, spender, amount);
   
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

 
  function _transfer(address sender, address recipient, uint256 amount) internal  {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");

    _beforeTokenAction(sender, recipient, amount);

    _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }


  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: mint to the zero address");

    _beforeTokenAction(account, address(0), amount);
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }


  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _beforeTokenAction(account, address(0), amount);
    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }



   function _beforeTokenAction(address from, address to, uint256 amount) internal virtual { }

}