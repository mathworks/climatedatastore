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
                cdsapiClient = cdsapi_ClientMock(options);
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




