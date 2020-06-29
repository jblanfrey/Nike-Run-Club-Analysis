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
    
%     function
%       
%     end
  end
end
