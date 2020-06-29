classdef activitySummaryViewer < activityViewer
  %ACTIVITYSUMMARYVIEWER Displays NRC activity summary
  
  properties
    Title
    Label
  end
  
  methods
    function view = activitySummaryViewer(parent, act)
      view = view@activityViewer(parent, act);
      
      Title = uilabel(view.GridLayout);
      Title.Layout.Row = 1;
      Title.Layout.Column = 1;
      Title.Text = "";
      Title.HorizontalAlignment = "center";
      Title.FontWeight = "bold";
      Title.FontSize = 16;
      view.Title = Title;
      
      Label = uilabel(view.GridLayout);
      Label.Layout.Row = 2;
      Label.Layout.Column = 1;
      Label.Text = "";
      Label.HorizontalAlignment = "center";
      view.Label = Label;
      
      % Update
      view.updateView();
    end
  end
    
  methods (Access = protected)
    function view = updateView(view, ~, ~)
      view.Title.Text = view.Activity.NickName + " - " + string(view.Activity.Date);
      
      s = view.Activity.Summary;
      t = milliseconds(view.Activity.DurationMS);
      t.Format="hh:mm:ss";
      pace = minutes(s.value(s.metric=="pace"));
      pace.Format = "mm:ss";
      view.Label.Text = ...
        "Distance: " + s.value(s.metric=="distance") + " km - " + ...
        "Average pace: " + string(pace) + " min/km - " + ...
        "Time: " + string(t);
    end
  end
end

