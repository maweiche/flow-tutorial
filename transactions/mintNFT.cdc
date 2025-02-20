import GarageNFT from "../contracts/GarageNFT.cdc";

// This transaction allows the Minter account to mint an NFT
// and deposit it into its collection.

transaction {

    // The reference to the collection that will be receiving the NFT
    let receiverRef: &{GarageNFT.NFTReceiver}

    // The reference to the Minter resource stored in account storage
    let minterRef: &GarageNFT.NFTMinter

    prepare(acct: AuthAccount) {
        // Get the owner's collection capability and borrow a reference
        self.receiverRef = acct.getCapability<&{GarageNFT.NFTReceiver}>(GarageNFT.CollectionPublicPath)
            .borrow()
            ?? panic("Could not borrow receiver reference")

        // Borrow a capability for the NFTMinter in storage
        self.minterRef = acct.borrow<&GarageNFT.NFTMinter>(from: GarageNFT.MinterStoragePath)
            ?? panic("Could not borrow minter reference")
    }

    execute {
        // Use the minter reference to mint an NFT, which deposits
        // the NFT into the collection that is sent as a parameter.
        let newNFT <- self.minterRef.mintNFT()

        self.receiverRef.deposit(token: <-newNFT)

        log("NFT Minted and deposited to Account 2's Collection")
    }
}