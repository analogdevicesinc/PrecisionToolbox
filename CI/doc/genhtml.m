mfiledir = '..\..\+adi\';
docdir = '..\..\doc\';
parts = {'AD4630','AD4030','AD463x','AD7625', 'AD7626', 'AD7960',
        'AD7961','AD7768','AD4858','AD2S1210','AD4000', 'AD4001',
	'AD4002', 'AD4003', 'AD4004', 'AD4005', 'AD4006', 'AD4007',
	'AD4008', 'AD4010', 'AD4011', 'AD4020', 'AD4021', 'AD4022',
	'AD7944', 'AD7985', 'AD7986'};
trx_files = {'Rx','Base','Tx'};
for ii = 1:numel(parts)
    for jj = 1:numel(trx_files)
        dotmfilename = strcat(mfiledir, '+', parts{ii}, '\', trx_files{jj}, '.m');
        if isfile(dotmfilename)
            htmlfilename = strcat(docdir, parts{ii}, '_', trx_files{jj}, '.html');
            html = customDoc(dotmfilename);
            dlmwrite(htmlfilename, html, 'delimiter', '');
            use_local_css(htmlfilename)
            disp(htmlfilename);
        end
    end
end
publish('SysObjsProps.m','outputDir','..\..\doc');
publish('ADITTBHome.m','outputDir','..\..\doc');

%{
[filepath,name,ext] = fileparts(mfilename('fullpath'));
cd(filepath);
files = dir(filepath);

target = '../../doc/';

skip = {'NA'};

for f = {files.name}
    if strfind(f{:},'.mlx')>=0
        filename = f{:};
        if contains(filename,skip)
            continue;
        end
        htmlFilename = [filename(1:end-4),'.html'];
        disp(htmlFilename);
        matlab.internal.liveeditor.openAndConvert(filename,htmlFilename);
        movefile(htmlFilename,target);
    end
end
%}


