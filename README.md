# Climate Data Store Toolbox for MATLAB

[![View Climate Data Store Toolbox on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/104550-climate-data-store-toolbox-for-matlab) [![GitHub top language](https://img.shields.io/github/languages/top/mathworks/climatedatastore)](https://matlab.mathworks.com/)  [![Climate Data CI/CD](https://github.com/mathworks/climatedatastore/actions/workflows/main.yml/badge.svg)](https://github.com/mathworks/climatedatastore/actions/workflows/main.yml) [![GitHub issues by-label](https://img.shields.io/github/issues-raw/mathworks/climatedatastore/bug)](https://github.com/mathworks/climatedatastore/issues?q=is%3Aissue+is%3Aopen+label%3Abug) ![GitHub Repo stars](https://img.shields.io/github/stars/mathworks/climatedatastore?style=social)

![MATLAB Code Issues](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmathworks%2Fclimatedatastore%2Fmain%2Freports%2Fbadge%2Fcode_issues.json) ![MATLAB Versions Tested](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmathworks%2Fclimatedatastore%2Fmain%2Freports%2Fbadge%2Ftested_with.json) 

MATLAB&reg; Tools to access [The Climate Data Store](https://cds.climate.copernicus.eu/).  It is a wealth of information about the Earth's past, present and future climate. There are hundreds of data sets associated with climate change. This toolbox allows you to easily access data and download it for analysis in MATLAB.

Please report bugs and suggest enhancements by [creating a new issue on GitHub](https://github.com/mathworks/climatedatastore/issues).

More info on installing and using the toolbox [below](#using-the-climate-data-store-toolbox).

## Collaborating on the Climate Data Store Toolbox

We're always excited to have people make improvements large and small to Climate Data Store Toolbox.  **Contributions do not have to be code!** If you see a way to explain things more clearly or a great example of how to use something, please contribute it (or a link to your content).  Please [create issues](https://github.com/mathworks/climatedatastore/issues) even if you don't code the solution.  We also welcome pull requests to resolve issues that we haven't gotten to yet!  See [CONTRIBUTING.MD](CONTRIBUTING.MD) for more information.

### How to get started improving the toolbox:

1. **Clone the repository:**  using MATLAB:
   1. In MATLAB, switch to the directory where you want the project created.
   1. Right click in the current folder browser, and choose *Source Control/Manage Files...*
   1. Set the repository path to `https://github.com/mathworks/climatedatastore.git`, and set Sandbox to the directory you want created.  
   1. Click (Retrieve).  Files will be cloned locally.
1. Open the `climatedatastore.prj` -- You're ready to make edits!
1. When you're done, run the test suite.
1. Create a pull request.

**Looking for ideas?** Fix a ["good first" issue!](https://github.com/mathworks/climatedatastore/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

### MATLAB Features Used

This demonstrates a number of MATLAB features, including:

* [Calling Python From MATLAB](https://www.mathworks.com/help/matlab/call-python-libraries.html)
* [Toolbox Packaging](https://www.mathworks.com/help/matlab/matlab_prog/create-and-share-custom-matlab-toolboxes.html)
* [MATLAB Projects](https://www.mathworks.com/help/matlab/projects.html)
* [Argument validation](https://www.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html)
* Code Issue detection using [Code Analyzer](https://www.mathworks.com/help/matlab/matlab_prog/check-code-for-errors-and-warnings.html) and [Code Issues](https://www.mathworks.com/help/matlab/ref/codeissues.html)
* [Unit Tests](https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html)
  * [Code Coverage using Cobertura report format](https://www.mathworks.com/help/matlab/ref/matlab.unittest.plugins.codecoverage.coberturaformat-class.html)
  * [Mocking Framework](https://www.mathworks.com/help/matlab/mock-dependencies-in-tests.html)
  * [Parameters in Unit Tests](https://www.mathworks.com/help/matlab/matlab_prog/use-parameters-in-class-based-tests.html)
* [MATLAB Classes](https://www.mathworks.com/help/matlab/object-oriented-programming.html)
  * [Static Methods](https://www.mathworks.com/help/matlab/matlab_oop/static-methods.html)
  * [Property Access Methods](https://www.mathworks.com/help/matlab/matlab_oop/property-set-methods.html)
* [`buildtool`](https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html) to run automated checks and tests
* [GitHub Actions](https://github.com/matlab-actions/overview)
  * [Action to setup MATLAB](https://github.com/matlab-actions/overview#setup-matlab) Configure a MATLAB session
  * Multi-release testing: Run tests across a number of MATLAB releases [(see yaml)](https://github.com/mathworks/climatedatastore/blob/main/.github/workflows/release.yml)
  * [Action to run MATLAB Build](https://github.com/matlab-actions/overview#run-matlab-build) Run automated checks and tests when new code is pushed to repo [(see yaml)](https://github.com/mathworks/climatedatastore/blob/main/.github/workflows/main.yml)
  * [Action to run MATLAB Code](https://github.com/matlab-actions/overview#run-matlab-command) Run automated tests and release a new version when a new tag is created. [(see yaml)](https://github.com/mathworks/climatedatastore/blob/main/.github/workflows/release.yml)

## Using the Climate Data Store Toolbox

*This is just a quick overview -- install and look at `GettingStarted.mlx` for more information on using the Toolbox.*

### Functions

| Function | Description |
| ------ | ------ |
|  `climateDataStoreDownload` | Get data from Copernicus Climate Data Store |
|  `climateDataStoreDownloadAsync` | Queue a request data from Copernicus Climate Data Store and continue working in MATLAB. |

### Usage

   1. See the notes below for information on first time install
   2. type `help climateDataStoreDownload` or  `help climateDataStoreDownloadAsync` for help on using the functions
   3. Find your dataset at [Climate Data Store](https://cds.climate.copernicus.eu/datasets) and click on the "download data" tab.  Make your selections for the subset of data you want.  Click "show API request" at the bottom.
   4. Use `climateDataStoreDownload` to get the data.  The first parameter is the name of the data set to retrieve.  The second parameter is a MATLAB version of the python structure that selects what subset of the data to download. `climateDataStoreDownload` downloads the files, and returns a list of files that were downloaded.

Note that downloading the files can take some time, depending on how large they are. If you have really large files, `climateDataStoreDownloadAsync` can be helpful. For an example of using the asynchronous download, see `toolbox/doc/AsyncDownloadExample.m`. You can check on the status of your request by visiting [the CDS request status page](https://cds.climate.copernicus.eu/requests?tab=all).

   Typically, files returned are:

   | File Type | Extension | MATLAB Functions |
   |-----------|-----------|------------------|
   | NetCDF    | `.nu`       | [`ncinfo`](https://www.mathworks.com/help/matlab/ref/ncinfo.html) , [`ncread`](https://www.mathworks.com/help/matlab/ref/ncread.html) |
   | GRIB      | `.grib`      | [`ncinfo`](https://www.mathworks.com/help/matlab/ref/ncinfo.html) , [`ncread`](https://www.mathworks.com/help/matlab/ref/ncread.html) |
   | text      | `.txt` , `.csv` | [`readtable`](https://www.mathworks.com/help/matlab/ref/readtable.html)

### First time Install

* Requires MATLAB release R2020a or later
* Install the toolbox by using the Add-on explorer in MATLAB, or by downloading the `climatedatastore.mltbx` file attached to the latest release on GitHub, then doubleclicking on it.
* This relies on the [CDS Python API](https://github.com/ecmwf/cdsapi) created by the European Centre for Medium-Range Weather Forecasts (ECMWF). You'll need to have python installed.  Get it from the [Python Download page](https://www.python.org/downloads/). See [this MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) for more information.
* The toolbox will automatically configure python and download and install the CSAPI package (you can manually install using `pip3 install cdsapi`)
* The toolbox will prompt you the first time for CSAPI credentials.  Visit [How to use the CDS API](https://cds.climate.copernicus.eu/how-to-api) for more info.

### Example: Getting Started with Copernicus Climate Data Store Toolbox

[The sea ice thickness dataset](https://cds.climate.copernicus.eu/datasets/satellite-sea-ice-thickness?tab=overview) provides monthly gridded data of sea ice thickness for the Arctic region based on satellite radar altimetry observations. Sea ice is an important component of our climate system and a sensitive indicator of climate change. Its presence or its retreat has a strong impact on air-sea interactions, the Earth’s energy budget as well as marine ecosystems. It is recognized by the Global Climate Observing System as an Essential Climate Variable. Sea ice thickness is one of the parameters commonly used to characterize sea ice, alongside sea ice concentration, sea ice edge, and sea ice type, also available in the Climate Data Store.

Select the sea ice thickness dataset.

```matlab:Code
datasetName ="satellite-sea-ice-thickness";
```

Select the data to download from the dataset (see [this webpage](https://cds.climate.copernicus.eu/datasets/satellite-sea-ice-thickness?tab=download) for options). This is a "MATLABized" version of the python structure that is generated in the API request.

```matlab:Code
datasetOptions = struct();
datasetOptions.version = "1_0";
datasetOptions.variable = "all";
datasetOptions.satellite = "cryosat_2";
datasetOptions.cdr_type = ["cdr","icdr"]; 
datasetOptions.year = ["2011","2021"]; 
datasetOptions.month = "03";
```

Download the data from Climate Data Store using **`climateDataStoreDownload`**. It is put in a directory called "satellite-sea-ice-thickness."

```matlab:Code
downloadedFilePaths = climateDataStoreDownload(datasetName,datasetOptions);
```

```text:Output
2021-11-10 10:38:13,694 INFO Welcome to the CDS
2021-11-10 10:38:13,697 INFO Sending request to https://cds.climate.copernicus.eu/api/v2/resources/satellite-sea-ice-thickness
2021-11-10 10:38:13,830 INFO Request is completed
2021-11-10 10:38:13,832 INFO Downloading https://download-0003.copernicus-climate.eu/cache-compute-0003/cache/data7/dataset-satellite-sea-ice-thickness-639d640c-3099-42c0-8878-6c335586d2c7.zip to C:\Users\rpurser\AppData\Local\Temp\tp3e8d85e3_9026_4531_ad2b_f3199a006857.zip (4.4M)
2021-11-10 10:38:15,378 INFO Download rate 2.8M/s
```

#### **Read and format ice thickness data from 2011 and 2021.**

Transform and load the latitude, longitude, and ice thickness.

```matlab:Code
ice2011 = readSatelliteSeaIceThickness(downloadedFilePaths(1));
ice2021 = readSatelliteSeaIceThickness(downloadedFilePaths(2));
head(ice2021)
```

| |time|lat|lon|thickness|
|:--:|:--:|:--:|:--:|:--:|
|1|01-Mar-2021|47.6290|144.0296|2.4566|
|2|01-Mar-2021|47.9655|144.0990|2.5800|
|3|01-Mar-2021|50.5072|148.0122|-0.0364|
|4|01-Mar-2021|50.8360|148.1187|1.0242|
|5|01-Mar-2021|50.3237|146.9969|0.0518|
|6|01-Mar-2021|51.1642|148.2269|0.2445|
|7|01-Mar-2021|50.9112|147.6573|0.8933|
|8|01-Mar-2021|50.6540|147.0948|0.1271|

Citation: *Generated using Copernicus Climate Change Service information 2025*

#### **Visually compare March ice thickness in 2011 and 2021**

```matlab:Code
subplot(1,2,1)
geodensityplot(ice2011.lat,ice2011.lon,ice2011.thickness,"FaceColor","interp")
geolimits([23 85],[-181.4 16.4])
geobasemap("grayterrain")
title("Ice Thickness, March 2011")

subplot(1,2,2)
geodensityplot(ice2021.lat,ice2021.lon,ice2021.thickness,"FaceColor","interp")
geolimits([23 85],[-181.4 16.4])
geobasemap("grayterrain")
title("Ice Thickness, March 2021")
f = gcf;
f.Position(3) = f.Position(3)*2;
```

![figure_0.png](images/icevisualization.png)

Citation: *Generated using Copernicus Climate Change Service information 2025*

## License

The license is available in the License file within this repository

Note: *each data set in the Copernicus Climate Data Store has its own license terms.  You should review the license terms for the data set that you are planning to use to ensure that it can be used in the way that you have planned.*

&copy; 2021-2025, The MathWorks, Inc.
