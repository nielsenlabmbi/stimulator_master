function makeLoop

%this function generates the looper structure for the experiment; it takes
%Lstate, which is set in updateLstate
%returns:
%  changes in the global variable looperInfo

global Lstate GUIhandles looperInfo

looperInfo = struct;  %reset 

Nparam = length(Lstate.param); %number of looper parameters

%Produces a cell array 'd', with each element corresponding to a different
%looper variable (parameter).  Each element contains a multidimensional array from
%ndgrid with as many elements as there are conditions. They are id's, not
%actually variable values.
nc = 1; %nr of conditions
for i = 1:Nparam
    eval(['paramV = ' Lstate.param{i}{2} ';']);
    nc = nc*length(paramV);
    if i == 1
        istring = ['1:' num2str(length(paramV))]; %input string for 'meshgrid'
        ostring = ['d{' num2str(i) '}'];  %output string for meshgrid
    else
        istring = [istring ',1:' num2str(length(paramV))];
        ostring = [ostring ',' 'd{' num2str(i) '}'];
    end
    
end

istring = ['ndgrid(' istring ')'];
ostring = ['[' ostring ']'];
eval([ostring ' = ' istring ';']);


%blanks?
bflag = get(GUIhandles.looper.blankflag,'value');
bPer = str2num(get(GUIhandles.looper.blankPeriod,'string')); %blanks per repeat


                    

%Create random sequence across conditions, for each repeat
nr = str2num(get(GUIhandles.looper.repeats,'string'));
tv=[1:nc];
if bflag==1
    tv(end+1:end+bPer)=nc+1;
end
    
for rep = 1:nr    
    if get(GUIhandles.looper.randomflag,'value')
        seq{rep} = tv(randperm(length(tv)));  
    else                          
        seq{rep} = tv;                                   
    end                            
end 


%Make the analyzer structure
if bflag==0
    ntrialPerRep=nc;
else
    ntrialPerRep=nc+bPer;
end

%for each parameter value, save info and trials in which it is used
for c = 1:nc
    for p = 1:Nparam
        idx = d{p}(c); %parameter value for condition c

        paramS = Lstate.param{p}{1}; %parameter name
        eval(['paramV = ' Lstate.param{p}{2} ';']);  %parameter values

        looperInfo.conds{c}.symbol{p} = paramS;
        looperInfo.conds{c}.val{p} = paramV(idx);
    end
    
    for r = 1:nr
        pres = find(seq{r} == c);
        looperInfo.conds{c}.repeats{r}.trialno = ntrialPerRep*(r-1) + pres;      
    end
    
end

%add the blanks
if bflag==1
    for p = 1:Nparam
        looperInfo.conds{nc+1}.symbol{p} = 'blank';
        looperInfo.conds{nc+1}.val{p} = [];
    end
    for r = 1:nr
        pres = find(seq{r} == nc+1);
        looperInfo.conds{nc+1}.repeats{r}.trialno = ntrialPerRep*(r-1) + pres;      
    end
end


%Put the formula in looperInfo
looperInfo.formula = get(GUIhandles.looper.formula,'string');


