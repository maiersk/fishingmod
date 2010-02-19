local Queries = { 
    Update = "UPDATE Fishingmod SET Catches = %d, Exp = %d WHERE UniqueID = %s",
    Get = "SELECT * FROM Fishingmod WHERE UniqueID = %s",
    Create = "INSERT INTO Fishingmod( UniqueID, Exp, Catches ) VALUES( %s, 0, 0 )",
    Table = "CREATE TABLE Fishingmod ( UniqueID varchar(255), Catches int, Exp int )"
}

function fishingmod.GainEXP(ply, Amount )
	ply.fishingmod_exp = ply.fishingmod_exp + Amount
	ply.fishingmod_catches = ply.fishingmod_catches + 1
	fishingmod.UpdatePlayerInfo(ply)
    sql.Query( Queries.Update:format( ply.fishingmod_catches, ply.fishingmod_exp, SQLStr(ply:UniqueID()) ) )
end

hook.Add( "PlayerInitialSpawn", "Fishingmod:ExpPlayerJoined", function( ply )
	timer.Simple(3, function()
		if not IsValid(ply) then return end
		local Query = sql.Query( Queries.Get:format( SQLStr(ply:UniqueID()) ) )
		if( !Query ) then
			sql.Query( Queries.Create:format( SQLStr(ply:UniqueID()) ) )
			ply.fishingmod_catches = 0
			ply.fishingmod_exp = 0
			fishingmod.UpdatePlayerInfo(ply)
			return
		end
		ply.fishingmod_catches = tonumber(Query[1].Catches)
		ply.fishingmod_exp = tonumber(Query[1].Exp)
		fishingmod.UpdatePlayerInfo(ply)
	end)

end )

if( !sql.TableExists( "Fishingmod" ) ) then
	sql.Query( Queries.Table )
end