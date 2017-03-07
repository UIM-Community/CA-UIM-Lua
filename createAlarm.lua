-- This code has been created by Rowan COLLINS.


-- Generates a nimid
function generate_NimID()
    local key = "";
    local base = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    math.random();math.random();
    key = mid(base,math.random(1,26),1) .. mid(base,math.random(1,26),1) ..
    sprintf("%07d",math.random(1,100000000)) .. "-" ..
    sprintf("%05d",math.random(1,100000))
    return key;
end
 
-----------------------------------------------------------------------------------------
-- generateAlarm (source,severity,subsystem,message ]]]])
-- returns 0 - ok, rest error
---
function generateAlarm (source,severity,subsystem,message,suppkey,domain,origin,robot,probe,devid,metid,tzoffset,md5sum)

   -- expect following parameters
   if type(severity) ~= "number" then return 1 end
   if type(message) ~= "string" then return 1 end
   if type(subsystem) ~= "string" then return 1 end
   if type(source) ~= "string" then return 1 end
 
   -- set default values for optional parameters.
   if type(domain) ~= "string" then domain="rc82-dom" end
   if type(origin) ~= "string" then origin="customerA" end
   if type(robot) ~= "string" then robot="colro22-i147145" end
   if type(probe) ~= "string" then probe="nas-lua-script" end
   if type(suppkey) ~= "string" then suppkey="lua-suppkey" end
   if type(tzoffset) ~= "number" then tzoffset=0 end
   if type(devid) ~= "string" then devid="" end
   if type(metid) ~= "string" then metid="" end
 
 
 
   msg = pds.create ()
   nimid = generate_NimID()
  
   -- Create message header
   pds.putString (msg,"nimid",nimid)
   pds.putInt    (msg,"nimts",timestamp.now() )
   pds.putInt    (msg,"tz_offset",tzoffset)
   pds.putString (msg,"source",source)
   pds.putString (msg,"md5sum","")
   pds.putString (msg,"robot",robot)
   pds.putString (msg,"domain",domain)
   pds.putString (msg,"origin",origin)
   pds.putInt    (msg,"pri",severity)
   pds.putString (msg,"subject","alarm")
   pds.putString (msg,"suppression","y+000000000#" .. suppkey)
   pds.putString (msg,"supp_key",suppkey)
   pds.putString (msg,"prid",probe)
   pds.putString (msg,"dev_id",devid)
   pds.putString (msg,"met_id",metid)
  
   -- Add raw alarm data
   udata = pds.create()
   pds.putInt    (udata,"level",severity)
   pds.putString (udata,"subsys",subsystem)
   pds.putString (udata,"message",message)
  
   pds.putPDS (msg,"udata",udata)
  
   -- Post the message to the hub-spooler
   t,rc = nimbus.request ("spooler","hubpost",msg)
 
   pds.delete (udata)
   pds.delete (msg)

   return rc,nimid

end
 
-- initialize the random generator
math.randomseed(os.time());
 
rc,id = rawalarm ("10.131.60.70",3,"1.2.3"," RAW:  This is a simple test...")
--printf ("rawalarm: %s, %d",id,rc)
 
--rc,id = rawalarm (a.source,a.level,a.sid,"RAW : "..a.message,a.supp_key,"2e2",a.origin,a.robot,a.prid,a.dev_id,a.met_id,a.tz_offset,a.md5sum)
--source,severity,subsystem,message,suppkey,domain,origin,robot,probe
--rawalarm (a.source,a.pri,a.subsys,a.message,a.supp_key,"2e2",a.origin,a.robot,a.prid)
--rc = rawalarm (a.source,a.pri,a.subsys,a.message,a.supp_key,"2e2",a.origin,a.robot,a.prid)
 
 
printf ("rawalarm: %s, %d",id,rc);
