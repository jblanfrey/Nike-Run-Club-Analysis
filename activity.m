classdef activity < handle
  properties (Access = private)
    Data = [];
    Metrics= [];
  end
  
  properties (Access = private)
    Filename_
  end
  
  properties (Dependent, SetObservable)
    Filename
  end
  
  properties (Dependent, SetAccess = private)
    Latitude
    Longitude
    Elevation
    Time
    Summary
    NickName
    DurationMS
    Date
  end
  
  methods
    function act = activity(filename)
      arguments
        filename (1,1) string = "";
      end
      if nargin
        assert(exist("data/" + filename, "file") == 2, ...
          "activity:FileNotFound", ...
          "Unable to locate the specified file %s.", filename);
        act.updateActivity(filename);
        act.Filename_ = filename;
      end
    end
  end % Constructor
  
  methods
    function updateActivity(act, filename)
      Data = load("data/" + filename);
      act.Data = Data.data;
      Metrics = struct2table(act.Data.metrics);
      Metrics.type = categorical(Metrics.type);
      Metrics.unit = categorical(Metrics.unit);
      Metrics.source = [];
      Metrics.appId = [];
      act.Metrics = Metrics;
    end
  end % updateActivity when the filename is changed
  
  methods
    function value = get.Latitude(act)
      if isempty(act.Metrics)
        value = [];
      else
        LatStruct = act.Metrics.values{act.Metrics.type=="latitude"};
        value = [LatStruct(:).value];
      end
    end
    
    function value = get.Longitude(act)
      if isempty(act.Metrics)
        value = [];
      else
        LonStruct = act.Metrics.values{act.Metrics.type=="longitude"};
        value = [LonStruct(:).value];
      end
    end
    
    function value = get.Elevation(act)
      if isempty(act.Metrics)
        value = [];
      else
        ElevStruct = act.Metrics.values{act.Metrics.type=="elevation"};
        value = [ElevStruct(:).value];
      end
    end
    
    function value = get.Time(act)
      if isempty(act.Metrics)
        value = [];
      else
        TimeStruct = act.Metrics.values{act.Metrics.type=="latitude"};
        value = datetime([TimeStruct(:).start_epoch_ms]./1000, 'ConvertFrom','posixtime');
      end
      
    end
    
    function value = get.Summary(act)
      if isempty(act.Metrics)
        value = [];
      else
        value = struct2table(act.Data.summaries);
        value.metric = categorical(value.metric);
        value.summary = categorical(value.summary);
        value.source = [];
        value.app_id = [];
      end
    end
    
    function value = get.NickName(act)
      if isempty(act.Metrics)
        value = [];
      else
        try
          value = act.Data.tags.com_nike_name;
        catch
          try
            value = act.Data.tags.com_nike_running_goaltype;
          catch
            value = act.Data.type;
          end
        end
      end
    end
    
    function value = get.Date(act)
      if isempty(act.Metrics)
        value = [];
      else
        d = datetime(act.Data.start_epoch_ms/1000,'ConvertFrom','posixtime','TimeZone','Australia/Sydney');
        value = d;
      end
    end
    
    function value = get.DurationMS(act)
      if isempty(act.Metrics)
        value = [];
      else
        value = act.Data.active_duration_ms;
      end
    end
    
    function value = get.Filename(act)
      value = act.Filename_;
    end
    
    function set.Filename(act, filename)
      assert(exist("data/" + filename, "file") == 2, ...
        "activity:FileNotFound", ...
        "Unable to locate the specified file %s.", filename);
      act.updateActivity(filename);
      act.Filename_ = filename;
    end
  end % getter and setter
  
  methods
    function exportToGPX(act)
      docNode = com.mathworks.xml.XMLUtils.createDocument('gpx');
      
      gpx = docNode.getDocumentElement;
      gpx.setAttribute('version','1.1');
      gpx.setAttribute('creator','JB');
      
      trk = docNode.createElement('trk');
      gpx.appendChild(trk);
      
      name = docNode.createElement('name');
      nameText = docNode.createTextNode(act.NickName);
      name.appendChild(nameText);
      trk.appendChild(name);
      
      trkseg = docNode.createElement('trkseg');
      trk.appendChild(trkseg);
      
      Date = act.Time;
      Date.Format = 'uuuu-MM-dd';
      Time = act.Time;
      Time.Format = 'HH:mm:ss';
      text = string(Date) + "T" + string(Time) + "Z";
      
      for k=1:numel(act.Latitude)
        trkpt = docNode.createElement('trkpt');
        trkpt.setAttribute('lat', num2str(act.Latitude(k),'%.50f'));
        trkpt.setAttribute('lon', num2str(act.Longitude(k),'%.50f'));
        trkseg.appendChild(trkpt);
        
        ele = docNode.createElement('ele');
        eleText = docNode.createTextNode(num2str(act.Elevation(k),'%.50f'));
        ele.appendChild(eleText);
        trkpt.appendChild(ele);
        
        time = docNode.createElement('time');
        timeText = docNode.createTextNode(text(k));
        time.appendChild(timeText);
        trkpt.appendChild(time);
      end
      
      xmlwrite(extractBefore(act.Filename,".mat") + '.xml',docNode);
    end
  end
end