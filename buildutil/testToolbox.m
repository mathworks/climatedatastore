function testToolbox(connectToServer, showReports)
%RUNTESTWITHCODECOVERAGE Summary of this function goes here
%   Detailed explanation goes here

    arguments
        connectToServer (1,1) logical = false;
        showReports (1,1) logical = false;
    end
    
    import matlab.unittest.plugins.codecoverage.CoverageReport
    import matlab.unittest.plugins.codecoverage.CoberturaFormat
    
        outputDirectory = "report";
        if isempty(dir(outputDirectory))
            mkdir(outputDirectory)
        end
        import matlab.unittest.plugins.CodeCoveragePlugin
        P = matlab.unittest.parameters.Parameter.fromData('useMock', struct('value', ~connectToServer));
        suite = matlab.unittest.TestSuite.fromClass(?climateDataStoreDownloadTest,'ExternalParameters',P);
        runner = testrunner("textoutput");
    
        if showReports
            htmlReport = CoverageReport(outputDirectory,MainFile = "codecoverage.html");
            p = CodeCoveragePlugin.forFolder("climatedatastoreToolbox","Producing",htmlReport);
            runner.addPlugin(p)
        else
            xmlReport = CoberturaFormat(fullfile(outputDirectory,"codecoverage.xml"));
            p = CodeCoveragePlugin.forFolder("climatedatastoreToolbox","Producing",xmlReport);
            runner.addPlugin(p)
        end
    
        results = runner.run(suite);
        results.generateHTMLReport(outputDirectory,MainFile = "testreport.html");
    
        if showReports
            web(fullfile(outputDirectory,"testreport.html"))
            web(fullfile(outputDirectory,"codecoverage.html"))
        else
            % Generate the JSON files for the shields in the readme.md
            codecovInfo = readstruct(fullfile(outputDirectory,"codecoverage.xml"));
            codeCoverage = round(codecovInfo.line_rateAttribute * 100,1);
            if codeCoverage > 95
                color = "green";
            elseif codeCoverage > 85
                color = "orange";
            elseif codeCoverage > 75
                color = "yellow";
            else
                color = "red";
            end
            writeBadgeJSONFile("code coverage",codeCoverage + "%", color)
        end
        
        results.assertSuccess()
end