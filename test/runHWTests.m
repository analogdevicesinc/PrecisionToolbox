function runHWTests(board)

import matlab.unittest.TestRunner;
import matlab.unittest.TestSuite;
import matlab.unittest.plugins.TestReportPlugin;
import matlab.unittest.plugins.XMLPlugin
import matlab.unittest.plugins.DiagnosticsValidationPlugin
import matlab.unittest.parameters.Parameter
import matlab.unittest.plugins.ToUniqueFile;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.constraints.ContainsSubstring;
import matlab.unittest.selectors.HasName;
import matlab.unittest.selectors.HasProcedureName;

switch board
    case "zynq-zed-ad7380"
        at = 'AD7380';
    case {"zynq-zed-ad7768", ...
            "zynq-zed-adv7511-ad7768-axi-adc-precision"}
        at = 'AD7768';
    case {"zynq-zed-adv7511-ad7768-1-evb", ...
            "zynq-zed-adv7511-ad7768-1-evb-precision"}
        at = 'AD7768_1';
    case "zynq-zed-ad4030"
        at = 'AD4030';
    case "zynq-zed-ad4630-16"
        at = 'AD4630_16';
    case {"zynq-zed-ad4630-24", ...
        "zynq-zed-adv7511-ad4630-24-precision"}
        at = 'AD4630_24';
    
    otherwise
        error('%s unsupported for HW test harness', board);
end
ats = {'AD7380Tests','AD7768Tests','AD7768_1Tests','AD4030Tests',...
        'AD4630_16Tests','AD4630_24Tests'};

if nargin == 0
    suite = testsuite(ats);
else
    suite = testsuite(ats);
    suite = selectIf(suite,HasProcedureName(ContainsSubstring(at,'IgnoringCase',true)));
end

try
    
    runner = matlab.unittest.TestRunner.withTextOutput('OutputDetail',1);
    runner.addPlugin(DiagnosticsValidationPlugin)
    xmlFile = board+"_HWTestResults.xml";
    plugin = XMLPlugin.producingJUnitFormat(xmlFile);
    
    runner.addPlugin(plugin);
    results = runner.run(suite);
    
    t = table(results);
    disp(t);
    disp(repmat('#',1,80));
    fid = fopen('failures.txt','a+');
    for test = results
        if test.Failed
            disp(test.Name);
            fprintf(fid,string(test.Name)+'\n');
        end
    end
    fclose(fid);
catch e
    disp(getReport(e,'extended'));
    bdclose('all');
    exit(1);
end
save(['BSPTest_',datestr(now,'dd_mm_yyyy-HH_MM_SS'),'.mat'],'t');
bdclose('all');
exit(any([results.Failed]));
end
