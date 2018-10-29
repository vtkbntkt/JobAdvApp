sfdx force:org:list

sfdx force:org:delete -u JobAdvApp2
sfdx force:org:create -f -s config/project-scratch-def.json -a JobAdvApp2 --durationdays 30
sfdx force:org:create -f -s config/project-scratch-def.json -a JobAdvApp2 - JobAdvAppOrg
sfdx force:source:push -u JobAdvApp2
sfdx force:source:push -u -f JobAdvApp2
sfdx force:data:tree:import --sobjecttreefiles data/Job_Advertisement__c.json
sfdx force:user:permset:assign -n JobAdvertisement -u JobAdvApp2
sfdx force:org:open -u JobAdvApp2
sfdx force:source:pull -u JobAdvApp2



