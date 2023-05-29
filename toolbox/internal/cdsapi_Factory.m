classdef (Sealed, Hidden) cdsapi_Factory < handle

    properties (Access = private)
        UseMocks logical = false;
    end

    methods (Static)
        function result = useMocks(useMocks)
            theFactory = cdsapi_Factory.getInstance();
            if nargin == 1
                theFactory.UseMocks = useMocks;
            end
            if nargout == 1
                result = theFactory.UseMocks;
            end
            
        end

        function cdsapiClient = getCdsapi(options)
            theFactory = cdsapi_Factory.getInstance();
            if theFactory.UseMocks
                % Do not directly call the constructor of the mock object that is ONLY used by automated test system.
                % That way, dependency analysis does not try to include the test infrastructure as part of the toolbox.
                % Note if we just do eval("cdsapi_ClientMock(options)"), the dependency system is smart enough to resolve that!
                mockName = "cdsapi_ClientMock(options)";
                cdsapiClient = eval(mockName); %#ok<EVLCS> 
            else
                cdsapiClient = cdsapi_Client(options);
            end
        end
    end

    methods (Static, Access = private)
        function theFactory = getInstance
            persistent factoryInstance
            if isempty(factoryInstance) || ~isvalid(factoryInstance)
                factoryInstance = cdsapi_Factory;
            end
            theFactory = factoryInstance;
        end
    end

    methods (Access = private)
        function obj = cdsapi_Factory
        end
    end
end




