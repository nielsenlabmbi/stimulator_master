function setShutter(cond)

%sets the shutter correctly for a particular condition

global looperInfo  


bflag = strcmp(looperInfo.conds{cond}.symbol{1},'blank');

if bflag==0  %if it is not a blank condition - shutter will not be moved in blanks
    
    %evaluate all Mstate parameters locally, in case of dependencies in the
    %formula
    Mf = fields(Mstate);
    for i = 1:length(fields(Mstate))
        eval([Mf{i} '= Mstate.'  Mf{i} ';' ])
    end
    
    %For the same reason, evaluate all parameters in Pstate
    %this needs to happen only locally
    for i = 1:length(Pstate.param)
        eval([Pstate.param{i}{1} '= Pstate.param{i}{3};' ])
    end
    
    %for each parameter in the looper, get value for the current condition
    %and execute any shutter related parameter settings
    Nparams = length(looperInfo.conds{cond}.symbol);
    for i = 1:Nparams
        pval = looperInfo.conds{cond}.val{i};
        psymbol = looperInfo.conds{cond}.symbol{i};
        eval([psymbol '=' num2str(pval) ';'])  %May be used to evaluate formula below (dependencies);
        
        eyefunc(psymbol,pval)  %This moves the eye shutters if its the right symbol
    end
    
    %evaluate the formula - we're using the entire formula here so that we
    %can use if statements etc; execute only shutter related commands
    fmla=looperInfo.formula;
    if ~isempty(fmla)
        if fmla(end)~=';'
            fmla=[fmla ';'];
        end
        eval(fmla);
    
        %now go through and find variables in the formula; append them with
        %their values to the message to the slave 
        %find equal signs (variables are before them)
        ide=strfind(fmla,'=');
        
        %remove == and ~= (for if statements)
        id2=strfind(fmla,'==');
        if ~isempty(id2)
            ide(ide==id2 | ide==id2+1) = [];
        end
        
        id2=strfind(fmla,'~=');
        if ~isempty(id2)
            ide(ide==id2+1)=[];
        end
        
        %now loop through = and get variable names - between equal and
        %previous ;
        ids=strfind(fmla,';');
        
        for e = 1:length(ide);
            
            delim1 = max(find(ids<ide(e)));
            if isempty(delim1)
                delim1=1;
            else
                delim1 = ids(delim1)+1;
            end
               
            psymbol_Fmla = fmla(delim1:ide(e)-1);
            pval_Fmla = eval(psymbol_Fmla);
            
            %evaluate shutter related symbols
            eyefunc(pval_Fmla,psymbol_Fmla);
        end
    end
            
end



function eyefunc(sym,bit)

if strcmp(sym,'Leye_bit')
    moveShutter(1,bit);
    waitforDisplayResp;
elseif strcmp(sym,'Reye_bit')
    moveShutter(2,bit);
    waitforDisplayResp;
elseif strcmp(sym,'eye_bit')
    switch bit
        case 0
            moveShutter(1,1);
            waitforDisplayResp
            moveShutter(2,0);
            waitforDisplayResp
        case 1
            moveShutter(1,0);
            waitforDisplayResp
            moveShutter(2,1);
            waitforDisplayResp
        case 2
            moveShutter(1,1);
            waitforDisplayResp
            moveShutter(2,1);
            waitforDisplayResp
        otherwise
    end
end
    



