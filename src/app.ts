import {ethers} from "ethers"
import fs from "fs"
import path from "path"

async function main() {
	const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545")
	const wallet = new ethers.Wallet(
		"0xc21a44d3054c039a8a423ddba904ee21f3932f07dc2e477abb417722ec93d5f6",
		provider
	)

    const abi = fs.readFileSync(path.join(__dirname, "../contracts_FundMe_sol_FundMe.abi"), "utf8")
    const binary = fs.readFileSync(path.join(__dirname, "../contracts_FundMe_sol_FundMe.bin"), "utf8")

    const contractFactory = new ethers.ContractFactory(abi, binary, wallet)
    console.log("Start Deploying Contract")
    const contract = await contractFactory.deploy("0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612")
    console.log("Finished Deploying Contract", contract)
}

main()
.then((result) => console.log(`Done: ${result}`))
.catch((err) => {
    console.error(`Error: ${err}`)
    process.exit(1)
})
