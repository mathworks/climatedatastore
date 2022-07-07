function testToolbox(options)
    %RUNTESTWITHCODECOVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    arguments
        options.ConnectToServer (1,1) logical = false;
        options.HtmlReports (1,1) logical = false;
        options.ReportSubdirectory (1,1) string = "";
    end
    
    import matlab.unittest.TestSuite;
    import matlab.unittest.TestRunner;
    import matlab.unittest.Verbosity;
    import matlab.unittest.plugins.CodeCoveragePlugin;
    import matlab.unittest.plugins.XMLPlugin;
    import matlab.unittest.plugins.codecoverage.CoverageReport;
    import matlab.unittest.plugins.codecoverage.CoberturaFormat;
    import matlab.unittest.selectors.HasTag;
    
    oldpath  = addpath("test",genpath("climatedatastoreToolbox"));
    finalize = onCleanup(@()(path(oldpath)));

    outputDirectory = fullfile("report",options.ReportSubdirectory);
    if isempty(dir(outputDirectory))
        mkdir(outputDirectory)
    end
    
    P = matlab.unittest.parameters.Parameter.fromData('useMock', struct('value', ~options.ConnectToServer));
    suite = TestSuite.fromClass(?smokeTest,'ExternalParameters',P);
    if ~options.ConnectToServer
        suite = suite.selectIf(HasTag('SupportsMock'));
    end
    
    runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed);

    codecoverageFileName = fullfile(outputDirectory,"codecoverage.xml");
    
    if options.HtmlReports
        htmlReport = CoverageReport(outputDirectory,'MainFile',"codecoverage.html");
        p = CodeCoveragePlugin.forFolder("climatedatastoreToolbox","Producing",htmlReport);
        runner.addPlugin(p)
    else
        runner.addPlugin(XMLPlugin.producingJUnitFormat(fullfile(outputDirectory,'test-results.xml')));
        runner.addPlugin(CodeCoveragePlugin.forFolder({'climatedatastoreToolbox'}, 'IncludingSubfolders', false, 'Producing', CoberturaFormat(codecoverageFileName)));
    end
    
    results = runner.run(suite);

    if ~verLessThan('matlab','9.9') && ~isMATLABReleaseOlderThan("R2022a")
        % This report is only available in R2022a and later.  isMATLABReleaseOlderThan wasn't added until MATLAB 2020b / version 9.9
        results.generateHTMLReport(outputDirectory,'MainFile',"testreport.html");
    end
    results.assertSuccess()
end
