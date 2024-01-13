% AirfoilModifier.m

classdef AirfoilModifier < handle
    properties
        airfoilCoordinates
        flipped
        angleOfAttack
        scale
        chordLength
        fileName
    end
    
    methods
        % Constructor
        function obj = AirfoilModifier(airfoilCoordinates, flipped, angleOfAttack, scale, fileName)
            obj.airfoilCoordinates = airfoilCoordinates;
            obj.flipped = flipped;
            obj.angleOfAttack = angleOfAttack*-1;
            obj.scale = scale;
            obj.fileName = fileName;

            obj.chordLength = max(airfoilCoordinates(:, 1)) - min(airfoilCoordinates(:, 1));
        end

        % calculate chord length
        function calcChordLen(obj)
            obj.chordLength = max(obj.airfoilCoordinates(:, 1)) - min(obj.airfoilCoordinates(:, 1));
        end

        % scale airfoil
        function scaleAirfoil(obj)
            obj.airfoilCoordinates = obj.scale * obj.airfoilCoordinates;
        end
        
        % flip airfoil
        function flipAirfoil(obj)
            if obj.flipped
                obj.airfoilCoordinates(:, 2) = -obj.airfoilCoordinates(:, 2);
            end
        end
        
        % rotate airfoil
        function rotateAirfoil(obj)
            theta = deg2rad(obj.angleOfAttack);
            rotationMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
            obj.airfoilCoordinates = obj.airfoilCoordinates * rotationMatrix;
        end
        
        % export modified airfoil to text file
        function exportAirfoil(obj)
            modifiedAirfoil = [obj.airfoilCoordinates(:, 1), obj.airfoilCoordinates(:, 2), obj.airfoilCoordinates(:, 3)];
            save(obj.fileName, 'modifiedAirfoil', '-ascii');
        end
        
        % plot airfoil
        function plot(obj)
            figure;
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