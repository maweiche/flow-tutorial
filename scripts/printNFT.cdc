// Print the NFTs owned by account 0x02.
import GarageNFT from "../contracts/GarageNFT.cdc";
pub fun main() {
    // Get the public account object for account 0x02
    let nftOwner = getAccount(0xa54eb815f7084b01)

    // Find the public Receiver capability for their Collection
    let capability = nftOwner.getCapability<&{GarageNFT.NFTReceiver}>(GarageNFT.CollectionPublicPath)

    // borrow a reference from the capability
    let receiverRef = capability.borrow()
            ?? panic("Could not borrow receiver reference")

    // Log the NFTs that they own as an array of IDs
    log("Account 2 NFTs")
    log(receiverRef.getIDs())
}