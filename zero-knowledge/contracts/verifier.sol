// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point p) pure internal returns (G1Point) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function addition(G1Point p1, G1Point p2) internal returns (G1Point r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point p, uint s) internal returns (G1Point r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] p1, G2Point[] p2) internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point a1, G2Point a2, G1Point b1, G2Point b2) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2,
            G1Point d1, G2Point d2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }
    function verifyingKey() pure internal returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point([0xf3f408d2bc3f51dc3c00c99ebd66aba2253cea7fdf3a5c9f912358197b05f74, 0x13659340f4f6341dbb3ef7c032be44694ed428ea6f11ddd001f35a73c0044cf9], [0x1c706f3935470926064002699025a0619dfd9b57ece09bb6a07915d135335ea4, 0xd6d14f16f9ae44f6179e1143f90ac84cf3e294ff228fcbd5664bde6b9879c33]);
        vk.B = Pairing.G1Point(0x6d188e95e8690b4bb933ec643d615475434395e34d7fe101a5a6ee0603e3767, 0x21bc4a3280cd90560cbe9a8892016ee62212cd1ee52642890a75b1526f835805);
        vk.C = Pairing.G2Point([0x115f9515840902b62adf57fe92870dc007d65a2f5916da4877193a342421ee99, 0x2ab55bc18464e76846380ff064825a4c3de4fa6c8432815527fe2e92280be61f], [0x16f240f2758de29d0fdbda3f4e8651b94334ee0b6e719bee02ffc66a82cb8e6, 0x1fe9c2583a24671c4d99dc1900183a8fee6c3195ee633f3f10431251471c3843]);
        vk.gamma = Pairing.G2Point([0x881b8325ad6bfc0c02aad20a36d236c51c31f9905df3e76e4e57663236d9294, 0x2bd5727293a93ad6579cf781b2a3c576c180f2b9eec0169b27d6cb6451e0c00b], [0x823565a081d7249be81c57a7eaaf869a09943df77f5a81c7532f91fffbe027, 0x8e104348f1d92ee14b0a669366748d5c49420532e7ff61ca882f0dc7871c979]);
        vk.gammaBeta1 = Pairing.G1Point(0x103a28945156124785dfbfc29a6b337cb61ae96683f3fabf442c08251a8c7101, 0xd6ece0b1d3b6db1d75fbe706826c19f461b9d6c685664fc04b1e9fd10c81785);
        vk.gammaBeta2 = Pairing.G2Point([0xb5b951747d7f744648bb6098f5c1f6bc2cdad5c34045364d18265fa7dcc4127, 0xf51e06b6672555333cba534273af7808a6553cd354c6b3f3ab3e7e9f80e0fa8], [0x14132fcb151b88d4a70b262a17fb8e248cd30a386cf43cbb0da5b2fb8008fa6d, 0x11e98ff548d9b2f5eed39074b0ba2e1f72df67d955208fee578ace8dba354d04]);
        vk.Z = Pairing.G2Point([0x9f05191be941b3d1d7f685efe4289fe0dce8a6e54403a563d61ea6da5018483, 0x254f80ff5961e25bcf7b1d26d40afd7e911fb86fe460ff18577865c9fd785a39], [0x20c748ce635a060d1108468f0e2943ff52200083ddc0a1eb795badcdb3cbfe8f, 0xcecc703383086a3ed4f66435c1b22aa472f478cbd2455ab57b211e53198e593]);
        vk.IC = new Pairing.G1Point[](3);
        vk.IC[0] = Pairing.G1Point(0xadc49208b8daf6732c9a1c1b7ffbb9be75d83be00811e4c9344abb374bfeed4, 0x2dd218ed882d624ac54899512fa4ba81f150f677c885c23810418cd68367ccaf);
        vk.IC[1] = Pairing.G1Point(0x26ac79311204d42e4ff943831322280ef9f9f345b334ff71b52dda99ea4aea69, 0x2c6f8e731bfc80416eb935f9e61064360bba4270a81c4b69d334ac480a988bd6);
        vk.IC[2] = Pairing.G1Point(0x21376678a99024b68c9b7d7815eaa8db7a18322793d6ae82d33ccc8e3c2cc18, 0xafcfcf43684d6384a5b9227369b38146f5f3cec1798f449d5d2e2352f216027);
    }
    function verify(uint[] input, Proof proof) internal returns (uint) {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++)
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd2(proof.A, vk.A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
        if (!Pairing.pairingProd2(vk.B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
        if (!Pairing.pairingProd2(proof.C, vk.C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
        if (!Pairing.pairingProd3(
            proof.K, vk.gamma,
            Pairing.negate(Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))), vk.gammaBeta2,
            Pairing.negate(vk.gammaBeta1), proof.B
        )) return 4;
        if (!Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A), proof.B,
                Pairing.negate(proof.H), vk.Z,
                Pairing.negate(proof.C), Pairing.P2()
        )) return 5;
        return 0;
    }
    event Verified(string s);
    function verifyTx(
            uint[2] a,
            uint[2] a_p,
            uint[2][2] b,
            uint[2] b_p,
            uint[2] c,
            uint[2] c_p,
            uint[2] h,
            uint[2] k,
            uint[2] input
        ) public returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }




    /*
    ********** Start of Customized Cross Selling Code *********** 
    */

    // User Struct whos elements will be used to determine VIP Level
    struct User {
        bytes32 userHash;           // ID number for the user
        string name;                // Name of user        // 1-10 based on how good they are at paying their bills
    }


    //Not Yet Implemented -- Have Credit Company Specify the weights to use for VIP Score calculation
    struct creditWeights {
        uint256 w1;
        uint256 w2;
        uint256 w3;
        uint256 w4;
        uint256 w5;
        uint256 w6;
    }

    creditWeights public weights = creditWeights(1,1,1,1,1,1);
    uint256[6] public weights2 = [1,1,1,1,1,1];

    uint256 id_num;

    uint256 num = 0;

    //List of all Users
    User[] allUsers;  

    //Mappings from ID -> User and ID -> VIP Score
    mapping(uint256=>User) BankUser;
    mapping(uint256=>uint256) VIPScore;

    event UserAdd(string user);

    constructor() public {
        addUser("Ken");
        addUser("Yijia");
        addUser("Nick");
        addUser("Melissa");
        addUser("Mari");
        addUser("Nicoli");
        addUser("Elon");
        addUser("Benjamin");
        addUser("Franklin");
        addUser("Franz");
    }

    function addUser(string name) public returns (uint256) {
        id_num = id_num + 1;
        bytes32 userHash = keccak256(abi.encodePacked(strConcat(bytes32ToString(bytes32(id_num)),name))); // need to add stuff to this!!
        User memory newUser = User(userHash, name);
        allUsers.push(newUser);
        BankUser[id_num] = newUser;
        emit UserAdd(name);
    }
    function strConcat(string _a, string _b) internal pure returns (string) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory abcde = new string(_ba.length + _bb.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        return string(babcde);
    }

    function bytes32ToString (bytes32 data) public pure returns (string) {
        bytes memory bytesString = new bytes(32);
        for (uint j = 0; j < 32; j++ ) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }


    event UpdateWeights(uint256 num);
    function setWeights(uint256[6] woah) public returns (uint256) {
        weights.w1 = woah[0];
        weights.w2 = woah[1];
        weights.w3 = woah[2];
        weights.w4 = woah[3];
        weights.w5 = woah[4];
        weights.w6 = woah[5];
        return weights.w1;

    }

    function getWeights() public view returns (uint256 w1, uint256 w2,uint256 w3,uint256 w4,uint256 w5,uint256 w6) {
        return (weights.w1, weights.w2, weights.w3, weights.w4, weights.w5, weights.w6);
    }

    function getUser(uint256 id) public view returns (bytes32 hash, string name) {
        User storage user = allUsers[id];
        return (user.userHash, user.name);
    }
        
}
