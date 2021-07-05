
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './BEP20.sol';
import './SafeMath.sol';
import './Authorization.sol';

contract BRAINS20 is BEP20, Authorization {
using SafeMath for uint256;


    constructor() BEP20("TOKEN EXAMPLE", "TOKEKENX", 18) {

        _initRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _initRole(PAUSER_ROLE, msg.sender);
        _initRole(MINTER_ROLE, msg.sender);
        _initRole(BURNER_ROLE, msg.sender);
    }


  

    function pause() public onlyOwner {
        require(hasRole(PAUSER_ROLE, msg.sender));
        _pause();
    }

    function unpause() public onlyOwner {
          require(hasRole(PAUSER_ROLE, msg.sender));
        _unpause();
    }

    function mint(uint256 amount) public  {
        require(hasRole(MINTER_ROLE, msg.sender));
        _mint(_msgSender(), amount);
    }

    function mintTo(address account, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender));
        _mint(account, amount);
    }




    function burn(uint256 amount) public returns (bool) {
        require(hasRole(BURNER_ROLE, msg.sender));
        _burn(_msgSender(), amount);
        return true;
    }

    function burnFrom(address account, uint256 amount) public  {
        require(hasRole(BURNER_ROLE, msg.sender));
        uint256 currentAllowance = allowance(account, _msgSender());
        _approve(account, _msgSender(), currentAllowance.sub(amount, "BEP20: burn amount exceeds balance"));
        _burn(account, amount);
    }



    function _beforeTokenAction(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenAction(from, to, amount);
    }

}