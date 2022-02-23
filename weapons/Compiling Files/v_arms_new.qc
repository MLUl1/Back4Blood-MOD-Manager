//$ModelName "weapons\arms\v_arms_producer_new.mdl"     //黑妹手臂
//$ModelName "weapons\arms\v_arms_coach_new.mdl"		//教练手臂
//$ModelName "weapons\arms\v_arms_mechanic_new"			//帽子手臂
//$ModelName "weapons\arms\v_arms_gambler_new.mdl"		//尼克手臂

//$ModelName "weapons\arms\v_arms_bill.mdl"				//比尔手臂
//$ModelName "weapons\arms\v_arms_louis.mdl"			//路易手臂
//$ModelName "weapons\arms\v_arms_francis.mdl"			//弗朗手臂
//$ModelName "weapons\arms\v_arms_zoey.mdl"				//佐伊手臂

//$ModelName "v_models\weapons\v_claw_Hunter_L4D1.mdl"
$ModelName "v_models\weapons\v_claw_Hunter.mdl"
$cdmaterials mlui2021\doaxvv\Nanami\Twilight_Time

$SurfaceProp "default"
$Contents "solid"
$CBox 0 0 0 0 0 0
$BBox -6.889 -20.236 0 15.463 20.209 59.867

$BodyGroup "arms"
{
	studio "SMD/armssss.smd"
}

$include "QCIs/Survivor_Arms_Bonemerge.qci"

$IncludeModel "v_models/weapons/anims_v_claw_Hunter.mdl"

$sequence reference "SMD/ref" fps 1
$sequence idle	    "SMD/ref" fps 30
