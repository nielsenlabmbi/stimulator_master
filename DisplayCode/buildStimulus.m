function buildStimulus(cond,trial)

global DcomState

%Sends loop information and buffers

global looperInfo Mstate

bflag = strcmp(looperInfo.conds{cond}.symbol{1},'blank');

if bflag
    %in the blanks, no stimulus needs to be built
    msg = 'L';
    
else
    mod = getmoduleID;
    
    msg = ['B;' mod ';' num2str(trial)];
    
    %This is done just in case there are dependencies in the 'formula' on
    %Mstate.
    Mf = fields(Mstate);
    for i = 1:length(fields(Mstate))
        eval([Mf{i} '= Mstate.'  Mf{i} ';' ])
    end
    
    %for each parameter in the looper, get value for the current condition
    Nparams = length(looperInfo.conds{cond}.symbol);
    for i = 1:Nparams
        pval = looperInfo.conds{cond}.val{i};
        psymbol = looperInfo.conds{cond}.symbol{i};
        msg = updateMsg(pval,psymbol,msg);
        eval([psymbol '=' num2str(pval) ';'])  %May be used to evaluate formula below (dependencies);
    end
    
    %Append the message with the 'formula' information
    fmla = looperInfo.formula;
    id = find(fmla == ' ');
    fmla(id) = [];
    if ~isempty(fmla)
        fmla = [';' fmla ';'];
        ide = find(fmla == '=');
        ids = find(fmla == ';'); % | fmla == ',');
        
        for e = 1:length(ide);
            
            delim1 = max(find(ids<ide(e)));
            delim1 = ids(delim1)+1;
            delim2 = min(find(ids>ide(e)));
            delim2 = ids(delim2)-1;
            
            try
                eval([fmla(delim1:delim2) ';'])  %any dependencies should have been established above
            catch ME
                
                if strcmp(ME.message(1:30),'Undefined function or variable')
                    
                    varname = ME.message(33:end-2);
                    pval = getParamVal(varname);  %get the value from Pstate
                    eval([varname '=' num2str(pval) ';'])
                    eval([fmla(delim1:delim2) ';'])  %try again
                end
            end
            
            psymbol_Fmla = fmla(delim1:ide(e)-1);
            pval_Fmla = eval(psymbol_Fmla);
            
            msg = updateMsg(pval_Fmla,psymbol_Fmla,msg);
        end
    end
    
end

msg = [msg ';~'];  %add the "Terminator"

fwrite(DcomState.serialPortHandle,msg);



function msg = updateMsg(pval,psymbol,msg)

global Pstate

id = find(psymbol == ' ');
psymbol(id) = []; %In case the user put in spaces with the entry

%Find parameter in Pstruct
idx = [];
for j = 1:length(Pstate.param)
    if strcmp(psymbol,Pstate.param{j}{1})
        idx = j;
        break;
    end
end

%change value based on looper
if ~isempty(idx)  %its possible that looper variable is not a grating parameter
    prec = Pstate.param{idx}{2};  %Get precision
    switch prec
        case 'float'
            msg = sprintf('%s;%s=%.4f',msg,psymbol,pval);
        case 'int'
            msg = sprintf('%s;%s=%d',msg,psymbol,round(double(pval)));
        case 'string'
            msg = sprintf('%s;%s=%s',msg,psymbol,pval);
    end
end

