{
  Sometime mods are released for another language, or author accidently
  edited some records and they got saved with a different language.
  This script will copy FULL and DESC subrecords from master to restore original names.
}
unit UserScript;

function Process(e: IInterface): integer;
var
  m: IInterface;
  mode: Char;
begin
// if U want only test (withoult apllying changes) set variable as 'test':	
  mode:= 'test';
  if not ElementExists(e, 'FULL') and not ElementExists(e, 'DESC') then
    Exit;

  // get master record
  m := Master(e);
  
  // no master - nothing to restore
  if not Assigned(m) then
    Exit;
  
  // if record overrides several masters, then get the last one
  if MasterCount(m) > 1 then
	begin
	m := OverrideByIndex(m, OverrideCount(m) - 2);
	AddMessage('---------------------------------------------------------------------------------------');
	AddMessage('more than one master. Setting master to: '+FullPath(m)+);
	end;

  if not SameText(GetElementEditValues(e, 'FULL'), GetElementEditValues(m, 'FULL')) then
	begin
	AddMessage('---------------------------------------------------------------------------------------');
	AddMessage('element: '+GetElementEditValues(e, 'FULL')+' ('+ShortName(e)+')');
	AddMessage('master: '+GetElementEditValues(m, 'FULL')+' ('+ShortName(m)+')');
	if (GetElementEditValues(m, 'FULL') = '') or (GetElementEditValues(m, 'FULL') = ' ') or (GetElementEditValues(m, 'FULL') = 'Creation Club Cell') then
		begin
			if not (mode = 'test') then
				begin
				AddMessage('master string EMPTY or master is ''Creation Club Cell'' - not restoring');
				end else 
				AddMessage('TEST MODE - no changes to plugins');

		Exit;
		end else
			begin
			if not (mode = 'test') then
				begin
				SetElementEditValues(e, 'FULL', GetElementEditValues(m, 'FULL')); 
	   			AddMessage('restoring FULL string: '+GetElementEditValues(m, 'FULL'));
				end else 
				AddMessage('TEST MODE - no changes to plugins');	
			end;
		end;


  if not SameText(GetElementEditValues(e, 'DESC'), GetElementEditValues(m, 'DESC')) then
    	begin
	AddMessage('---------------------------------------------------------------------------------------');
	AddMessage('element: '+GetElementEditValues(e, 'DESC')+' ('+ShortName(e)+')');
	AddMessage('master: '+GetElementEditValues(m, 'DESC')+' ('+ShortName(m)+')');
	if (GetElementEditValues(m, 'DESC') = '') or (GetElementEditValues(m, 'DESC') = ' ') or (GetElementEditValues(m, 'DESC') = 'Creation Club Cell') then
		begin
		AddMessage('master string EMPTY or master is ''Creation Club Cell'' - not restoring');
		Exit;
		end else
			begin
			if not (mode = 'test') then
				begin
				SetElementEditValues(e, 'DESC', GetElementEditValues(m, 'DESC')); 
   				AddMessage('restoring DESC string: '+GetElementEditValues(m, 'DESC'));
				end else 
				AddMessage('TEST MODE - no changes to plugins');
			end;
		end;
end;

end.
