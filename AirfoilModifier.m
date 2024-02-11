% AirfoilModifier.m
% in [X Z Y] format where Z is up

classdef AirfoilModifier < handle
    properties
        fileName
        outputFileName
        airfoilCoordinates
        angleOfAttack
        scale
        xTrans
        yTrans
        doFlip
        needY
        wantExport
        wantPlot
        chordLength
    end
    
    methods
        % constructor
        function obj = AirfoilModifier(fileName, outputFileName, angleOfAttack, scale, xTrans, yTrans, doFlip, needY, wantExport, wantPlot)
            obj.airfoilCoordinates = load(fileName);
            obj.outputFileName = outputFileName;
            obj.angleOfAttack = angleOfAttack*-1;
            obj.scale = scale;
            obj.xTrans = xTrans;
            obj.yTrans = yTrans;
            obj.doFlip = doFlip;
            obj.needY = needY;
            obj.wantExport = wantExport;
            obj.wantPlot = wantPlot;

            obj.solve();
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

        % translate airfoil
        function translateAirfoil(obj)
            obj.airfoilCoordinates(:, 1) = obj.airfoilCoordinates(:, 1) + obj.xTrans; % x
            obj.airfoilCoordinates(:, 2) = obj.airfoilCoordinates(:, 2) + obj.yTrans; % y
        end
        
        % export modified airfoil to text file
        function exportAirfoil(obj)
            % saves X Z Y into modifiedAirfoil and exports to some fileName
            modifiedAirfoil = [obj.airfoilCoordinates(:, 1), obj.airfoilCoordinates(:, 2), obj.airfoilCoordinates(:, 3)];
            save(obj.outputFileName, 'modifiedAirfoil', '-ascii');
        end
        
        % plot airfoil
        function plot(obj)
            figure;
            % only using X Z coords for plot
            plot(obj.airfoilCoordinates(:, 1), obj.airfoilCoordinates(:, 2), '');
            axis equal;
            grid on;
            xlabel('X');
            ylabel('Z');
            title(extractBefore(obj.outputFileName, '_') + " Wing");
            disp("Chord length: " + obj.chordLength);
        end

        % add 'Y' column of 0 [X Z Y]
        function yCol(obj)
            temp = zeros(size(obj.airfoilCoordinates, 1), 1);
            obj.airfoilCoordinates = [obj.airfoilCoordinates, temp];
        end

        % perform all modifications and export
        function solve(obj)
            obj.flipAirfoil();
            obj.rotateAirfoil();
            obj.scaleAirfoil();
            obj.translateAirfoil();
            obj.chordLength = max(obj.airfoilCoordinates(:, 1)) - min(obj.airfoilCoordinates(:, 1));

            if obj.needY
                obj.yCol(); % if DAT/txt file needs Y values 
            end
            if obj.wantPlot
                obj.plot();
            end
            if obj.wantExport
                obj.exportAirfoil();
            end
        end 
    end
end