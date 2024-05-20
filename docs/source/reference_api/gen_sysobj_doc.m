[filepath,name,ext] = fileparts(mfilename('fullpath'));
cd(filepath);

mfiledir = fullfile('adi');

rootClasses = {...
    {'AD7380',{'Rx'}}...
    , {'AD7768', {'Rx'}}...
    , {'AD7768_1', {'Rx'}}...
    , {'AD4030', {'Rx'}}...
    , {'AD4630_16', {'Rx'}}...
    , {'AD4630_24', {'Rx'}}...
    , {'AD4858', {'Rx'}}...
    , {'AD2S1210', {'Rx'}}...
    , {'AD4000', {'Rx'}}...
    , {'AD4001', {'Rx'}}...
    , {'AD4002', {'Rx'}}...
    , {'AD4003', {'Rx'}}...
    , {'AD4004', {'Rx'}}...
    , {'AD4005', {'Rx'}}...
    , {'AD4006', {'Rx'}}...
    , {'AD4007', {'Rx'}}...
    , {'AD4008', {'Rx'}}...
    , {'AD4010', {'Rx'}}...
    , {'AD4011', {'Rx'}}...
    , {'AD4020', {'Rx'}}...
    , {'AD4021', {'Rx'}}...
    , {'AD4022', {'Rx'}}...
    , {'AD5760', {'Tx'}}...
    , {'AD5780', {'Tx'}}...
    , {'AD5781', {'Tx'}}...
    , {'AD5790', {'Tx'}}...
    , {'AD5791', {'Tx'}}...
    , {'AD7124_4', {'Rx'}}...
    , {'AD7124_8', {'Rx'}}...
    , {'AD4052', {'Rx'}}...
    };

all_devs = [];
rstFiles = [];

for ii = 1:numel(rootClasses)
    for jj = 1:numel(rootClasses{ii}{2})
        part = rootClasses{ii}{1};
        tmp = rootClasses{ii}{2};
        trx_file = tmp{jj};
        all_props = [];
        dotmfilename = strcat(mfiledir, '.', part, '.', trx_file);
        props = unique(properties(dotmfilename));
        for prop = 1:length(props)

            if props{prop} == "enIO"
                continue;
            end
            pdoc = help(strcat(dotmfilename,'.',props{prop}));
            
            pdocs = strsplit(pdoc,'\n');
            prop_title = pdocs{1};
            prop_description = strip(replace(strjoin(pdocs(2:end),'\n'),'\n',''));
            prop_description = int32(prop_description);
            prop_description(prop_description==10) = [];
            prop_description(prop_description==13) = [];
            prop_description = char(prop_description);
            prop_description = replace(prop_description,'    ',' ');
            prop_description = replace(prop_description,'  ',' ');
            
            s = struct('prop_name',props{prop},...
                'prop_title',prop_title,...
                'prop_description',prop_description);
            all_props = [all_props,s];
        end
        top_doc = help(dotmfilename);
        top_doc = strsplit(top_doc,'\n');
        top_doc = top_doc(1:end - 3);
        top_doc = strtrim(top_doc); %Remove spurious leading whitespaces

        top_doc(1) = cellstr(strcat("**", top_doc(1), "**"));
        top_doc = strjoin(top_doc, '\n');
        top_doc = char(top_doc);
        
        oname = struct('name',dotmfilename, 'dec',top_doc, 'props',all_props);
        all_devs = [all_devs, oname];
    
        template = '';
        % Class name and section
        class_name = oname.name;
        template = append(template, class_name);
        template = append(template, '\n');
        template = append(template, repelem('-', length(class_name)), '\n');

        % Add description
        template = append(template, '\n', convertStringsToChars(top_doc));

        % Add properties
        template = append(template, '\n\n', 'Class Properties', '\n', repelem('=', 16), '\n\n'); %TODO replace hardcoded 16

        num_props = size(all_props, 2);
        for p = 1:num_props
            my_prop = all_props(p);
            prop_title = strtrim(my_prop.prop_title);
            prop_desc = strtrim(my_prop.prop_description);
            template = append(template, '**', prop_title, '**\n', '   ', prop_desc, '\n\n');
        end
        
        % Create file
        fileID = fopen([part '_' trx_file '.rst'],'wt');
        fprintf(fileID, template);
        fclose(fileID);

        rstFiles = [rstFiles, convertCharsToStrings(['   ' part '_' trx_file '.rst'])];
    end
    
end

%% Overwrite any existing index.rst file
if isfile('index_template.tmpl')
    template = [];
    fileID = fopen('index_template.tmpl','r');
    current_line = convertCharsToStrings(fgetl(fileID));

    while isstring(current_line)
        template = [template, current_line];
        current_line = convertCharsToStrings(fgetl(fileID));
    end
    fclose(fileID);

    fileID = fopen('index.rst','wt');
    for i = 1:length(template)
        fprintf(fileID, template(i));
        fprintf(fileID, '\n');
    end
    
    fclose(fileID);
    
end

%% Add toctree to the reference api index.rst file using the rstFiles
fileID = fopen('index.rst','a+');
fprintf(fileID, '\n');
for i = 1:length(rstFiles)
    fprintf(fileID, "%s", rstFiles(i));
    fprintf(fileID, '\n');
end
fclose(fileID);
