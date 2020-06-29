classdef activityTest < matlab.unittest.TestCase
  methods (Test)
    function emptyConstructorCorrectness(testCase)
      act = activity;
      verifyClass(testCase, act, "activity");
      % Check that the default properties have been set correctly.
      verifyEqual(testCase, act.Filename, []);
      verifyEqual(testCase, act.Latitude, []);
      verifyEqual(testCase, act.Longitude, []);
      verifyEqual(testCase, act.Elevation, []);
      verifyEqual(testCase, act.Summary, []);
      verifyEqual(testCase, act.NickName, []);
      verifyEqual(testCase, act.DurationMS, []);
      verifyEqual(testCase, act.Date, []);
    end
    
    function emptyConstructorUpdateFilename(testCase)
      act = activity;
      act.Filename = "activity-20200623-072233.mat";
      verifyLength(testCase, act.Latitude, 570);
    end
    
    function constructorErrors(testCase)
      % The constructor should error if the file does not exist.
      cmd = @() activity("NonExistentFile.xyz");
      verifyError(testCase, cmd, "activity:FileNotFound");
    end
  end
end
