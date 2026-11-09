

export type RBXCommandBody = {
	name: string,
	admin: boolean,
	aliases: { string }?,
	
	run: (ctx: TextSource, msg: string) -> ()
}

return nil