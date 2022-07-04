// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract SFTestStaking is ERC721Holder, Ownable {

    IERC721 public sfNft;
    IERC20 public sfToken;
    
    struct Stake{
        address stakedBy;
        uint256 stakedAt;
    }
    mapping(uint256 => Stake) public stakingDetails;
    mapping(address => uint256) public tokenStaked;
    uint256 public REWARD_RATE = 1 * 10**18; // 1 sfToken/sec

    address public stakingAddress;

    constructor(address _sfNft, address _sfToken, address _stakingAddress){
        sfNft = IERC721(_sfNft);
        sfToken = IERC20(_sfToken);
        stakingAddress = _stakingAddress;
    }
     
    //before transfer we have to approve this contract in NFT contract
    function stake(uint256 tokenId) external {
        
        sfNft.safeTransferFrom(msg.sender, address(this), tokenId);
        stakingDetails[tokenId] = Stake(msg.sender,block.timestamp);
        tokenStaked[msg.sender] += 1;
    }

    function calculateTokens(uint256 tokenId) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - stakingDetails[tokenId].stakedAt;
        return timeElapsed * REWARD_RATE;
    }

    function unstake(uint256 tokenId) external {

        require(stakingDetails[tokenId].stakedBy == msg.sender, "SFTestStaking: You can't unstake");
        sfToken.transferFrom(stakingAddress, msg.sender, calculateTokens(tokenId));
        sfNft.transferFrom(address(this), msg.sender, tokenId);
        tokenStaked[msg.sender] -= 1;
        delete stakingDetails[tokenId];
    }

    function setRewardRate(uint256 _rate) external onlyOwner{
        REWARD_RATE = _rate;
    }

    function setStakingAddress(address _addr) external onlyOwner{
        stakingAddress = _addr;
    }

    
}