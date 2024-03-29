function setShutter(cond)

%sets the shutter correctly for a particular condition

global looperInfo Mstate Pstate shutterInfo


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
    if ~isempty(looperInfo.formula{1})
        %formula can now be entered in multiple lines - gets returned as
        %char array
        %first transform into cell array to make things easier
        fmla=cellstr(looperInfo.formula);
        %remove empty lines
        fmla=fmla(~cellfun('isempty',fmla));
    
        %check to see whether there are 2 statements in 1 line - break up
        %for further processing
        %should have a ; in the middle of the statement, not at the end of
        %the line
        ids=strfind(fmla,';');
        for i=1:length(ids)
            if ~isempty(ids{i})
                if ids{i}<length(fmla{i})
                    %split the line with the semicolon
                    fmlaPart=strsplit(fmla{i},';');
                    
                    %need to insert into formula - shift everything else
                    %down, then insert
                    nLines=length(fmlaPart);
                    nOrig=length(fmla);
                    fmla(i+nLines:nOrig+nLines-1)=fmla(i+1:nOrig);
                    for j=1:nLines
                        fmla(i+j-1)=fmlaPart(j);
                    end
                end
            end
        end
        
        %evaluate formula - this will set the variables to their
        %correct values, which is necessary before sending them
        %(extra ; seem not to matter, so no further check)
        efmla=[];
        for i=1:length(fmla)
            efmla=[efmla fmla{i} ';'];
        end
        %disp(efmla);
        eval(efmla);
        
    
        %now go through and find shutter related variables
        
        %find equal signs (variables are before them)
        %returns a cell array of the same size as fmla
        ide=strfind(fmla,'=');
        
        %remove = in logical statements; these are instances in which there
        %is not a letter or number before the 
        for i=1:length(ide)            
            fmlaL=fmla{i}(max(ide{i})-1);
           % disp(fmlaL)
            if ~isstrprop(fmlaL,'alphanum') && ~isspace(fmlaL)
                ide{i}=[];
            end
        end
        
        %now loop through = and get variable names
        % to deal with if statements correctly, first find all names here
        for i=1:length(fmla)
            %disp(fmla{i})
            if ~isempty(ide{i})
                fmlaPart=strsplit(fmla{i},'=');                
                fmlaSymbol{i} = strtrim(fmlaPart{1});
                %disp(fmlaSymbol{i})
            end
        end
        fmlaUSymbol=unique(fmlaSymbol(~cellfun('isempty',fmlaSymbol)));
        
        %loop through and execute shutter related functions
        for i=1:length(fmlaUSymbol)
            sym=fmlaUSymbol{i};
            bit = eval(psymbol_Fmla);
            eyefunc(sym,bit);
            
        end %for symbol
    end %if isempty formula
            
end %if bflag

function eyefunc(sym,bit)
global shutterInfo

if strcmp(sym,'Leye_bit')
    if shutterInfo.LEopen==0
        bit=1-bit;
    end
    moveShutter(shutterInfo.LEch,bit);
    waitforDisplayResp;
elseif strcmp(sym,'Reye_bit')
    if shutterInfo.REopen==0
        bit=1-bit;
    end
    moveShutter(shutterInfo.REch,bit);
    waitforDisplayResp;
elseif strcmp(sym,'eye_bit')
    switch bit
        case 0 %LE open, RE closed
            moveShutter(shutterInfo.LEch,shutterInfo.LEopen);
            waitforDisplayResp
            moveShutter(shutterInfo.REch,1-shutterInfo.REopen);
            waitforDisplayResp
        case 1 %RE open, LE closed
            moveShutter(shutterInfo.LEch,1-shutterInfo.LEopen);
            waitforDisplayResp
            moveShutter(shutterInfo.REch,shutterInfo.REopen);
            waitforDisplayResp
        case 2 %both open
            moveShutter(shutterInfo.LEch,shutterInfo.LEopen);
            waitforDisplayResp
            moveShutter(shutterInfo.REch,shutterInfo.REopen);
            waitforDisplayResp
        otherwise
    end
end %if strcmp






