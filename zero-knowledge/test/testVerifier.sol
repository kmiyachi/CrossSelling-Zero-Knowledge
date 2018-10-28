pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/verifier.sol";

contract TestVIP {
    Verifier ver = Verifier(DeployedAddresses.verifier());



    // Testing the adopt() function
    function testNothing() public {
        ver.addUser("IDK");
        ver.creditWeights b = ver.getWeights();
        //uint256 s = vip.calculate_VIP(1);
        //uint256 idk = vip.calculate_VIP(2);
        Assert.equal(b.w1,1000,"Score is blank");
    }

}