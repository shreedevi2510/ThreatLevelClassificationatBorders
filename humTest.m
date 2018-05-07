clc; clear all; close all;

 vObj = VideoReader('C:\Users\shrik\Desktop\HumanDetection\testvideos\weapons\vid5.mp4');

 totalFrames = floor(vObj.Duration * vObj.FrameRate);

detector1 = vision.CascadeObjectDetector('HuDe.xml');
detector2 = vision.CascadeObjectDetector('ccvehicledetector.xml');
detector3 = vision.CascadeObjectDetector('gundataset.xml');


   videoPlayer = vision.VideoPlayer('Name', 'Threat Level Classification'); 

 humanFlag = 0;
 vehicleFlag = 0;
 weaponFlag = 0;
  
  humanCount = 0;
  vehicleCount=0;
  weaponCount=0;
 
 displayHumanFlag = '';
 displayVehicleFlag='';
 displayWeaponFlag='';
 threatFlag = 0;

%  iv = [];
%  iv1 = [22:60,82:100];
%  nf = [2,5,6,8,10,11,28,29,32,35,37,39,43,46,47,48,49,54,57];
%  nft = [];
%  counter = 1;
%  for i = iv1
%      if i > 60
%          nft = 81 + nf;
%      else
%          nft = 21 + nf;
%      end
%      if ~ismember(i,nft)
%          iv(counter) = i;
%          counter = counter + 1;
%      end
%  end
 %detectedFrame = [];
 for i = [1:500]
%     i
      img  = read(vObj, i);
%        imwrite(img,['C:\Users\shrik\Desktop\HumanDetection\trainHuman_Weapons\aa\weapon',num2str(i),'.png']);
%        imgo = img;
%       if videoPlayed == 'V'
%           img = imgo(71:360,1:500,:);
%       elseif videoPlayed == 'W'
%           img = imgo(71:360,1:275,:);
%       else
%           img = imgo;
%       end
            bbox1 = step(detector1,img);
            detectedImg1 = insertObjectAnnotation(img,'rectangle',bbox1,'Human');
            human = size(bbox1, 1);
            if human > 0
                humanFlag = 1;
%                 if humanCount < human
%                     humanCount=human;
%                 end
            humanCount=humanCount+human;
            end
%              detectedImg1 = insertText(detectedImg1, [10 100], humanCount, 'BoxOpacity', 1,'FontSize', 14);
            if humanFlag == 1
                displayHumanFlag = 'Human Detected';
            end
            detectedImg1 = insertText(detectedImg1, [10 200], displayHumanFlag, 'BoxOpacity', 1,'FontSize', 14);

            bbox2 = step(detector2,img);
            detectedImg2 = insertObjectAnnotation(img,'rectangle',bbox2,'Vehicle');
             vehicle = size(bbox2, 1);
             if vehicle > 0
                vehicleFlag = 1;
%                 if vehicleCount < vehicle
%                     vehicleCount=vehicle;
%                 end
                vehicleCount=vehicleCount+vehicle;
            end
%              detectedImg2 = insertText(detectedImg2, [10 100], vehicleCount, 'BoxOpacity', 1,'FontSize', 14);
            if vehicleFlag == 1
                displayVehicleFlag = 'Vehicle Detected';
            end
            detectedImg2 = insertText(detectedImg2, [10 200], displayVehicleFlag, 'BoxOpacity', 1,'FontSize', 14);

            bbox3 = step(detector3,img);
            detectedImg3 = insertObjectAnnotation(img,'rectangle',bbox3,'humanwithweapon'); 
             weapon = size(bbox3, 1);
             if weapon > 0
                weaponFlag = 1;
%                 if weaponCount < weapon
%                     weaponCount=weapon;
%                 end
                weaponCount=weaponCount+weapon;
                %detectedFrame = [detectedFrame, i];
            end
%             detectedImg3 = insertText(detectedImg3, [10 100], weaponCount, 'BoxOpacity', 1,'FontSize', 14);
            if weaponFlag == 1
                displayWeaponFlag = 'Weapons Detected';
            end   
            detectedImg3 = insertText(detectedImg3, [10 200], displayWeaponFlag, 'BoxOpacity', 1,'FontSize', 14);
                  
                       
            if (weapon>0)||(threatFlag == 3)
                ThreatLevel='Alert: Danger - Weapons Detected';
                AlertLevel = 'Threat Level: High';
                threatFlag = 3;
                
            elseif (vehicle>0)||(threatFlag == 2)
                ThreatLevel='Alert: Vehicle Alarm';
                AlertLevel = 'Threat Level: Medium';
                if threatFlag < 3
                    threatFlag = 2;
                end

            elseif (human>0)||(threatFlag == 1)
                ThreatLevel='Alert: Human Activity';
                AlertLevel = 'Threat Level: Low';
                if threatFlag < 2
                    threatFlag = 1;
                end
                
            else
                ThreatLevel='Alert: Safe';
                AlertLevel = 'Threat Level: None';
                if threatFlag < 1
                    threatFlag = 0;
                end
                
            end
            
           detectedImg=[detectedImg3, detectedImg1,detectedImg3]; 
           detectedImg=insertText(detectedImg, [10 50], ThreatLevel,'BoxOpacity', 1, ...
            'FontSize', 15);
           detectedImg=insertText(detectedImg, [10 10], AlertLevel,'BoxOpacity', 1, ...
            'FontSize', 20);
        
%            if (weapon > 0)&&(human<=1)&&(vehicle==0)
               step(videoPlayer,detectedImg) ; 
             
           
 end
 
release(videoPlayer);



