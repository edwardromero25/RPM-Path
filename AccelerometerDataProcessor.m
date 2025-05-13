classdef AccelerometerDataProcessor
    properties
        time_in_hours
        meas_x_acc
        meas_y_acc
        meas_z_acc
    end

    methods
        function obj = AccelerometerDataProcessor(filename)
            fid = fopen(filename, 'r');
            column = textscan(fid, '%s %s %f %f %f');
            fclose(fid);

            datetime_str = strcat(column{1}, {' '}, column{2});
            timestamp = datetime(datetime_str, 'InputFormat', 'yyyy/MM/dd HH:mm:ss.SSSSSS');
            obj.time_in_hours = hours(timestamp - timestamp(1));
            obj.meas_x_acc = column{3};
            obj.meas_y_acc = column{4};
            obj.meas_z_acc = column{5};
        end

        function [meas_x_acc, meas_y_acc, meas_z_acc, time_in_hours] = getData(obj)
            meas_x_acc = obj.meas_x_acc;
            meas_y_acc = obj.meas_y_acc;
            meas_z_acc = obj.meas_z_acc;
            time_in_hours = obj.time_in_hours;
        end
    end
end
