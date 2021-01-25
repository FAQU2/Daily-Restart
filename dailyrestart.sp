#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

ConVar gc_Restart;

public Plugin myinfo = 
{
	name = "Daily server restart",
	author = "FAQU"
}

public void OnPluginStart()
{
	CreateTimer(60.0, Timer_Restart, _, TIMER_REPEAT);
	
	RegAdminCmd("sm_systime", Command_Systemtime, ADMFLAG_ROOT, "Shows server system time");
	
	gc_Restart = CreateConVar("sm_restart_time", "05:45", "System time to restart the server at (24 hours format)");
	AutoExecConfig(true, "dailyrestart");
}

public Action Timer_Restart(Handle timer)
{
	int timestamp = GetTime();
	
	char time[32];
	FormatTime(time, sizeof(time), "%H:%M", timestamp);
	
	char restart[32];
	gc_Restart.GetString(restart, sizeof(restart));
	
	if (StrEqual(time, restart))
	{
		LogMessage("Automatic server restart");
		ServerCommand("_restart");
	}
}

public Action Command_Systemtime(int client, int args)
{
	int timestamp = GetTime();
	
	char time[32];
	FormatTime(time, sizeof(time), "%H:%M", timestamp);
	
	ReplyToCommand(client, "System Time: %s", time);
	return Plugin_Handled;
}