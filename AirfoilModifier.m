% AirfoilModifier.m

classdef AirfoilModifier < handle
    properties
        airfoilCoordinates
        doFlip
        angleOfAttack
        scale
        chordLength
        fileName
    end
    
    methods
        % Constructor
        function obj = AirfoilModifier(airfoilCoordinates, doFlip, angleOfAttack, scale, fileName)
            obj.airfoilCoordinates = airfoilCoordinates;
            obj.doFlip = doFlip;
            obj.angleOfAttack = angleOfAttack*-1;
            obj.scale = scale;
            obj.fileName = fileName;

            obj.chordLength = max(airfoilCoordinates(:, 1)) - min(airfoilCoordinates(:, 1));
        end

        % calculate chord length
        function calcChordLen(obj)
            % max x coord - min x coord
            obj.chordLength = max(obj.airfoilCoordinates(:, 1)) - min(obj.airfoilCoordinates(:, 1));
        end

        % scale airfoil
        function scaleAirfoil(obj)
            % multiplies all coords by some scale
            obj.airfoilCoordinates = obj.scale * obj.airfoilCoordinates;
        end
        
        % flip airfoil
        function flipAirfoil(obj)
            % if doFlip == true
            if obj.doFlip
                % multiply all y coord by -1, mirrored vertically
                obj.airfoilCoordinates(:, 2) = -obj.airfoilCoordinates(:, 2);
            end
        end
        
        % rotate airfoil
        function rotateAirfoil(obj)
            % convert AOA from deg -> rad
            theta = deg2rad(obj.angleOfAttack);
            % create 2x2 rotation matrix based on 
            % sin/cos values calculated from AOA 
            rotationMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
            % multiply all coords by rotation matrix 
            obj.airfoilCoordinates = obj.airfoilCoordinates * rotationMatrix;
        end
        
        % export modified airfoil to text file
        function exportAirfoil(obj)
            % saves X Y Z into modifiedAirfoil and exports to some fileName
            modifiedAirfoil = [obj.airfoilCoordinates(:, 1), obj.airfoilCoordinates(:, 2), obj.airfoilCoordinates(:, 3)];
            save(obj.fileName, 'modifiedAirfoil', '-ascii');
        end
        
        % plot airfoil
        function plot(obj)
            figure;
            % only using X Y coords for plot
            plot(obj.airfoilCoordinates(:, 1), obj.airfoilCoordinates(:, 2), '-o');
            axis equal;
            grid on;
            xlabel('X');
            ylabel('Y');
            title(extractBefore(obj.fileName, '_') + " Front Wing");
        end

        % add 'Z' column of 0
        function zCol(obj)
            temp = zeros(size(obj.airfoilCoordinates, 1), 1);
            obj.airfoilCoordinates = [obj.airfoilCoordinates, temp];
        end

        % perform all modifications and export
        function modify(obj)
            obj.flipAirfoil();
            obj.rotateAirfoil();
            obj.scaleAirfoil();
            obj.zCol(); % remove if DAT/txt file already contains Z values 
        end
        
    end
end