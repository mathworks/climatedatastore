function testToolbox(connectToServer, htmlReports)
    %RUNTESTWITHCODECOVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    arguments
        connectToServer (1,1) logical = false;
        htmlReports (1,1) logical = false;
    end
    
    import matlab.unittest.TestSuite;
    import matlab.unittest.TestRunner;
    import matlab.unittest.Verbosity;
    import matlab.unittest.plugins.CodeCoveragePlugin;
    import matlab.unittest.plugins.XMLPlugin;
    import matlab.unittest.plugins.codecoverage.CoberturaFormat;
    import matlab.unittest.selectors.HasTag;
    
    oldpath  = addpath("test",genpath("climatedatastoreToolbox"));
    finalize = onCleanup(@()(path(oldpath)));

    outputDirectory = "report";
    if isempty(dir(outputDirectory))
        mkdir(outputDirectory)
    end
    
    P = matlab.unittest.parameters.Parameter.fromData('useMock', struct('value', ~connectToServer));
    suite = TestSuite.fromClass(?smokeTest,'ExternalParameters',P);
    if ~connectToServer
        suite = suite.selectIf(HasTag('SupportsMock'));
    end
    
    runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed);
    
    if htmlReports
        htmlReport = CoverageReport(outputDirectory,'MainFile',"codecoverage.html");
        p = CodeCoveragePlugin.forFolder("climatedatastoreToolbox","Producing",htmlReport);
        runner.addPlugin(p)
    else
        runner.addPlugin(XMLPlugin.producingJUnitFormat('report/test-results.xml'));
        runner.addPlugin(CodeCoveragePlugin.forFolder({'climatedatastoreToolbox'}, 'IncludingSubfolders', false, 'Producing', CoberturaFormat('report/codecoverage.xml')));
    end
    
    results = runner.run(suite);

    if ~isMATLABReleaseOlderThan("R2022a")
        % This report is only available in R2022a and later.
        results.generateHTMLReport(outputDirectory,'MainFile',"testreport.html");
    end
    
    if ~htmlReports
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
        %writeBadgeJSONFile("code coverage",codeCoverage + "%", color)
    end
    
    results.assertSuccess()
end