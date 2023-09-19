// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstate is ERC721Enumerable, Ownable {
    struct Land {
        string location;
        string name;
        string desc;
        uint cost;
        uint landID;
        uint wantSell;
        address approver;
        bool buyerApproved;
        bool sellerApproved;
        address ownerAddress;
    }

    uint public totalLandsCounter; // total number of lands via this contract

    mapping (uint => Land) public lands;

    constructor() ERC721("RealEstate", "LAND") {
        totalLandsCounter = 0;
    }

    // Land addition event
    event Add(address indexed _owner, uint _landID);

    
    // Modifier to check if the caller is the owner of a specific land
    modifier isLandOwner(uint _landID) {
        require(_exists(_landID), "Land with this ID does not exist");
        require(ownerOf(_landID) == msg.sender, "Caller is not the owner of this land");
        _;
    }

    // Modifier to check if the caller is the agreed approver for a specific land transfer
    modifier isAgreedApprover(uint _landID) {
        require(_exists(_landID), "Land with this ID does not exist");
        require(lands[_landID].approver == msg.sender, "Caller is not the agreed approver for this land transfer");
        require(lands[_landID].buyerApproved == false && lands[_landID].sellerApproved == false, "Approval already given");
        require(lands[_landID].wantSell == 1, "Land is not available for sale");
        require(lands[_landID].cost <= msg.value, "Insufficient payment");
        _;
    }

    // Owner shall add lands via this function
    function addLand(string memory _location, string memory _name, string memory _desc, uint _cost) public onlyOwner {
        totalLandsCounter++;
        uint landID = totalLandsCounter;
        lands[landID] = Land({
            location: _location,
            name: _name,
            desc: _desc,
            cost: _cost,
            landID: landID,
            wantSell: 1,
            approver: address(0),
            buyerApproved: false,
            sellerApproved: false,
            ownerAddress: msg.sender
        });

        _mint(msg.sender, landID);
        emit Add(msg.sender, landID);
    }

    // Buyer and Seller agree on the approver before initiating the transfer process
    function agreeOnApprover(uint _landID, address _approver) public isLandOwner(_landID) {
        require(lands[_landID].approver == address(0), "Approver already set");
        lands[_landID].approver = _approver;
        lands[_landID].sellerApproved = true;
    }
    function removeApprover(uint _landID) public {
        require(lands[_landID].approver != address(0), "Approver is null already!");
        lands[_landID].approver = address(0);
        lands[_landID].sellerApproved = false;
    }

    // Buyer approves the transfer
    function approveTransferAsBuyer(uint _landID) public payable {
        require(lands[_landID].approver == msg.sender, "Caller is not the agreed approver for this land transfer");
        require(lands[_landID].buyerApproved == false, "Transfer already approved by the buyer");
        lands[_landID].buyerApproved = true;
        checkAndCompleteTransfer(_landID);
    }

    // Function to check if both buyer and seller have approved the transfer
    // If approved, complete the transfer
    function checkAndCompleteTransfer(uint _landID) private {
        if (lands[_landID].buyerApproved && lands[_landID].sellerApproved) {
            address oldOwner = ownerOf(_landID);
            _transfer(ownerOf(_landID), lands[_landID].approver, _landID);
            lands[_landID].ownerAddress = lands[_landID].approver;
            lands[_landID].wantSell = 0;
            lands[_landID].approver = address(0);
            lands[_landID].buyerApproved = false;
            lands[_landID].sellerApproved = false;

            address payable seller = payable(oldOwner);
            seller.transfer(lands[_landID].cost);
            emit Transfer(ownerOf(_landID), lands[_landID].approver, _landID);
        }
    }
   
    // Get land details of an account
    function getLand(uint _landID) public view returns (string memory, string memory, string memory, uint, address, uint, uint) {
        require(_exists(_landID), "Land with this ID does not exist");
        Land memory land = lands[_landID];
        return (land.location, land.name, land.desc, land.cost, ownerOf(_landID), land.landID, land.wantSell);
    }

    // Remove land from sale
    function removeFromSale(uint _landID) public isLandOwner(_landID) {
        lands[_landID].wantSell = 0;
    }
}