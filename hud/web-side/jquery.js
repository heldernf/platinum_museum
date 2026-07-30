import { oxygenHTML, stressHTML, armourHTML } from './template.js';
// -------------------------------------------------------------------------------------------
var Voip = "Normal";
var Interval = undefined;
const timeTransition = 400;
let inVehicle = false;
// -------------------------------------------------------------------------------------------
function Minimal(Seconds) {
	if (Seconds == 0) {
		return "00:00"
	} else {
		var Days = Math.floor(Seconds / 86400)
		Seconds = Seconds - Days * 86400
		var Hours = Math.floor(Seconds / 3600)
		Seconds = Seconds - Hours * 3600
		var Minutes = Math.floor(Seconds / 60)
		Seconds = Seconds - Minutes * 60

		const [D, H, M, S] = [Days, Hours, Minutes, Seconds].map(s => s.toString().padStart(2, 0))

		if (Days > 0) {
			return D + ":" + H
		} else if (Hours > 0) {
			return H + ":" + M
		} else if (Minutes > 0) {
			return M + ":" + S
		} else if (Seconds > 0) {
			return "00:" + S
		}
	}
}
// -------------------------------------------------------------------------------------------
const FormatNumber = n => {
	var n = n.toString();
	var r = "";
	var x = 0;

	for (var i = n["length"]; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
		x = x == 2 ? 0 : x + 1;
	}

	return r.split("").reverse().join("");
}
// -------------------------------------------------------------------------------------------
function resetStyleProgress() {
	clearInterval(Interval)

	setTimeout(() => {
		$("#Progress").fadeOut(500);

		// RESETA O CSS APLICADO
		setTimeout(() => {
			$("#ProgressBar").css("stroke-dashoffset", "360");
			$("#DotRotate").css("transform", "rotate(0deg)")
		}, 500);
	}, 100);
}
// -------------------------------------------------------------------------------------------
const StatusSideLeft = document.querySelector("#StatusSideLeft");
const StatusSideRight = document.querySelector("#StatusSideRight");
let armourExists = false;
let stressExists = false;
let oxygenExists = false;
let BottomContainerPlayerStatus = "";
// ORGANIZA TODOS OS STATUS (VIDA, COLETE, ESTRESSE, FOME, SEDE E OXIGÊNIO) DA 'COMEIA' DE STATUS DO PLAYER 
function organizeStatus(caller) {
	switch (caller) {
		case "Armour":
			if (armourExists) {
				StatusSideRight.insertBefore(armourHTML(), StatusSideRight.firstChild);

				if (stressExists || oxygenExists) {
					if (stressExists && oxygenExists) {
						StatusSideLeft.insertBefore(stressHTML(), StatusSideLeft.firstChild);
						StatusSideRight.insertBefore(oxygenHTML(), StatusSideRight.firstChild);
					} else if (stressExists || oxygenExists) {
						let insert = false
						stressExists ? insert = stressHTML() : insert = oxygenHTML()

						if (insert) {
							StatusSideLeft.insertBefore(insert, StatusSideLeft.firstChild);
						}
					}
				}
			} else {
				$("#ArmourBox").remove();

				if (stressExists || oxygenExists) {
					if (stressExists && oxygenExists) {
						StatusSideLeft.insertBefore(oxygenHTML(), StatusSideLeft.firstChild);
						StatusSideRight.insertBefore(stressHTML(), StatusSideRight.firstChild);
					} else if (stressExists || oxygenExists) {
						let insert = false
						stressExists ? insert = stressHTML() : insert = oxygenHTML()

						if (insert) {
							StatusSideRight.insertBefore(insert, StatusSideRight.firstChild);
						}
					}
				}
			}
			break;
		case "Stress":
			if (stressExists) {
				if (armourExists || oxygenExists) {
					if (armourExists && oxygenExists) {
						StatusSideLeft.insertBefore(stressHTML(), StatusSideLeft.firstChild);
						StatusSideRight.insertBefore(oxygenHTML(), StatusSideRight.firstChild);
					} else if (armourExists || oxygenExists) {
						let insert = false
						oxygenExists ? insert = oxygenHTML() : false

						if (insert) {
							StatusSideLeft.insertBefore(insert, StatusSideLeft.firstChild);
							StatusSideRight.insertBefore(stressHTML(), StatusSideRight.firstChild);
						} else {
							StatusSideLeft.insertBefore(stressHTML(), StatusSideLeft.firstChild);
						}
					}
				} else {
					StatusSideRight.insertBefore(stressHTML(), StatusSideRight.firstChild);
				}
			} else {
				$("#StressBox").remove();

				if (armourExists || oxygenExists) {
					if (armourExists && oxygenExists) {
						StatusSideLeft.insertBefore(oxygenHTML(), StatusSideLeft.firstChild);
					} else if (armourExists || oxygenExists) {
						let insert = false
						oxygenExists ? insert = oxygenHTML() : false

						if (insert) {
							StatusSideLeft.insertBefore(insert, StatusSideLeft.firstChild);
						}
					}
				}
			}
			break;
		case "Oxygen":
			if (oxygenExists) {
				if (stressExists || armourExists) {
					if (stressExists && armourExists) {
						StatusSideRight.insertBefore(oxygenHTML(), StatusSideRight.firstChild);
					} else if (stressExists || armourExists) {
						StatusSideLeft.insertBefore(oxygenHTML(), StatusSideLeft.firstChild);
					}
				} else {
					StatusSideRight.insertBefore(oxygenHTML(), StatusSideRight.firstChild);
				}
			} else {
				$("#OxygenBox").remove();
			}
			break;

	}

	// CALCULA O QUANTO DEVE REGREDIR O 'bottom' DO HUD PARA MANTER ELE CENTRALIZADO COM O MAPA
	if (inVehicle) {
		let extraStatus = 0;
		if (armourExists) {
			extraStatus++;
		}

		if (stressExists) {
			extraStatus++;
		}

		if (oxygenExists) {
			extraStatus++;
		}
		
		if (extraStatus > 0) {
			if (BottomContainerPlayerStatus == "") {
				BottomContainerPlayerStatus = parseFloat($("#containerPlayerStatus").get(0).style.bottom);
			}
			
			const statusHeightREM = parseFloat($(".playerStatus").css("height")) / 10; // DIVIDE POR 10 POR CONTA QUE O 'rem' NO DOCUMENTO CSS VALE 10 E NÃO 16
			const backToMiddle = BottomContainerPlayerStatus - (statusHeightREM / 4 * extraStatus) + "rem";

			$("#containerPlayerStatus").css("bottom", backToMiddle);
		}
	}
}
// -------------------------------------------------------------------------------------------
window.addEventListener("message", function (event) {
	switch (event["data"]["Action"]) {
		case "Progress":
			if ($("#Progress").css("display") === "block") {
				resetStyleProgress();

				return
			} else {
				$("#Progress").fadeIn(500)
				// $("#progressText").html(event["data"]["Message"] + "...");
			}

			let Percentage = 0;
			function Ticker() {
				Percentage++;

				if (Percentage <= 100) {
					$("#ProgressNum").html(Percentage + "%");
					$("#ProgressBar").css("stroke-dashoffset", 360 - Percentage * 360 / 100);
					$("#DotRotate").css("transform", `rotate(${Percentage * 360 / 100}deg)`)
				} else {
					resetStyleProgress();
				}
			}
			Interval = setInterval(Ticker, (event["data"]["Timer"] - 300) / 100);
			break;

		case "Frequency":
			if (event["data"]["Frequency"] == "Offline") {
				$("#Radio").html(event["data"]["Frequency"]);
				$("#RadioContainer").fadeOut(timeTransition)
			} else {
				$("#RadioContainer").fadeIn(timeTransition)
				$("#RadioContainer").css("display", "flex");

				$("#Radio").html(event["data"]["Frequency"]);
			}
			break;

		case "Body":
			if (event["data"]["Status"]) {
				if ($("#App").css("display") === "none") {
					$("#App").fadeIn(timeTransition);
				}
			} else {
				if ($("#App").css("display") !== "none") {
					$("#App").fadeOut(timeTransition);
				}
			}
			break;

		// case "Passport":
		// 	$(".Passport").html(FormatNumber(event["data"]["Number"]));
		// 	break;

		// case "Gemstone":
		// 	$(".Gemstone").html(FormatNumber(event["data"]["Number"]));
		// 	break;

		case "Voip":
			if (event["data"]["Voip"] == "Offline") {
				$("#Voip").html("Offline");
			} else {
				if (event["data"]["Voip"] !== "Online") {
					Voip = event["data"]["Voip"];
				}

				$("#Voip").html(Voip);
			}
			break;

		case "Voice":
			if (event["data"]["Status"]) {
				$("#Voip").css("background-color", "#00DB58");
				$(".boxIcon").eq(2).css("background-color", "#00DB58");
			} else {
				$("#Voip").css("background-color", "#00000040");
				$(".boxIcon").eq(2).css("background-color", "#00000066");
			}
			break;

		case "Clock":
			var Hours = event["data"]["Hours"];
			var Minutes = event["data"]["Minutes"];

			if (Hours <= 9)
				Hours = "0" + Hours

			if (Minutes <= 9)
				Minutes = "0" + Minutes

			$("#Date").html(Hours + ":" + Minutes);
			break;

		case "Wanted":
			if (event["data"]["Number"] >= 0) {
				if ($("#Wanted").css("display") === "none") {
					$("#Wanted").fadeIn(timeTransition);
					$("#Wanted").css("display", "flex");
				}

				$("#WantedTimer").html("Procurado | " + Minimal(event["data"]["Number"]));
			} else {
				if ($("#Wanted").css("display") != "none") {
					$("#Wanted").fadeOut(timeTransition);
				}
			}
			break;

		case "Reposed":
			if (event["data"]["Number"] >= 0) {
				if ($("#Reposed").css("display") === "none") {
					$("#Reposed").fadeIn(timeTransition);
					$("#Reposed").css("display", "flex");
				}

				$("#ReposedTimer").html("Repouso | " + Minimal(event["data"]["Number"]));
			} else if (hideReposed === true) {
				if ($("#Reposed").css("display") != "none") {
					$("#Reposed").fadeOut(timeTransition);
				}
			}
			break;

		case "Dexterity":
			if (event["data"]["Number"] >= 0) {
				if ($("#Dexterity").css("display") === "none") {
					$("#Dexterity").fadeIn(timeTransition);
					$("#Dexterity").css("display", "flex");
				}

				$("#DexterityTimer").html("Destreza | " + Minimal(event["data"]["Number"]))
			} else {
				if ($("#Dexterity").css("display") === "block") {
					$("#Dexterity").fadeOut(timeTransition);
				}
			}
			break;

		case "Luck":
			if (event["data"]["Number"] >= 0) {
				if ($("#Luck").css("display") === "none") {
					$("#Luck").fadeIn(timeTransition);
					$("#Luck").css("display", "flex");
				}

				$("#LuckTimer").html("Sorte | " + Minimal(event["data"]["Number"]))
			} else {
				if ($("#Luck").css("display") === "block") {
					$("#Luck").fadeOut(timeTransition);
				}
			}
			break;

		case "Road":
			$("#UpStreet").html(event["data"]["Name"]);
			break;

		// case "Crossing":
		// 	$(".DownStreet").html(event["data"]["Name"]);
		// 	break;

		case "Oxygen":
			if (event["data"]["Scubaequip"] === true) {
				if (!oxygenExists) {
					oxygenExists = true;
					organizeStatus("Oxygen");
				}

				if ($("#OxygenBox").css("display") === "none") {
					$("#OxygenBox").fadeIn(timeTransition);
				}

				const maxTimeInWater = event["data"]["TimeInWater"]
				const Oxygen = event["data"]["Number"] * 100 / maxTimeInWater
				$("#Oxigenio").css("stroke-dashoffset", 100 - Oxygen);
			} else {
				if ($("#OxygenBox").css("display") !== "none") {
					$("#OxygenBox").fadeOut(timeTransition);

					oxygenExists = false;
					organizeStatus("Oxygen");
				}
			}
			break;

		case "Health":
			$("#Health").css("stroke-dashoffset", 100 - event["data"]["Number"]);
			break;

		case "Armour":
			if (event["data"]["Number"] > 0) {
				if (!armourExists) {
					armourExists = true;
					organizeStatus("Armour");
				}

				if ($("#ArmourBox").css("display") === "none") {
					$("#ArmourBox").fadeIn(timeTransition);
				}

				$("#Armour").css("stroke-dashoffset", 100 - event["data"]["Number"]);
			} else {
				if ($("#ArmourBox").css("display") !== "none") {
					$("#ArmourBox").fadeOut(timeTransition);

					armourExists = false;
					organizeStatus("Armour");
				}
			}
			break;

		case "Thirst":
			$("#Thirst").css("stroke-dashoffset", 100 - event["data"]["Number"]);
			break;

		case "Hunger":
			$("#Hunger").css("stroke-dashoffset", 100 - event["data"]["Number"]);
			break;

		case "Stress":
			if (event["data"]["Number"] > 0) {
				if (!stressExists) {
					stressExists = true;
					organizeStatus("Stress");
				}

				if ($("#StressBox").css("display") === "none") {
					$("#StressBox").fadeIn(timeTransition);
				}

				$("#Stress").css("stroke-dashoffset", 100 - event["data"]["Number"]);
			} else {
				if ($("#StressBox").css("display") !== "none") {
					$("#StressBox").fadeOut(timeTransition);

					stressExists = false;
					organizeStatus("Stress");
				}
			}
			break;

		case "Vehicle":
			if (event["data"]["Status"]) {
				if ($("#Vehicle").css("display") === "none") {
					$("#Vehicle").fadeIn(timeTransition);
					$("#Vehicle").css("display", "grid");
				}

				// TRANSPORTA E MODIFICA OS STATUS DO PLAYER PARA O LADO DO MAPA
				$("#containerPlayerStatus").css("flex-direction", "row");
				$("#containerPlayerStatus").css("bottom", "5.8rem");
				$("#containerPlayerStatus").css("left", "28.5rem");

				inVehicle = true;
				organizeStatus();
			} else {
				if ($("#Vehicle").css("display") !== "none") {
					$("#Vehicle").fadeOut(timeTransition);
				}

				// REDEFINI OS STATUS DO PLAYER
				$("#containerPlayerStatus").css("flex-direction", "column");
				$("#containerPlayerStatus").css("bottom", "0");
				$("#containerPlayerStatus").css("left", "0");
				inVehicle = false;
			}
			break;

		case "Fuel":
			var fuelvalue = parseInt(event["data"]["Number"])
			$("#FuelProgress").css("stroke-dashoffset", 100 - fuelvalue);
			$("#gasolinaPorcento").html(fuelvalue + "%")
			break;

		case "Speed":
			var Max = 250;
			var Speed = parseInt(event["data"]["Number"]);

			if (Speed > Max)
				Max = event["data"]["Number"];

			// var SpeedValue = (Speed * 46) / Max
			// $(".SpeedProgress").css("stroke-dashoffset", (440 - (440 * SpeedValue) / 100));

			if (Speed < 10) {
				Speed = `<span id="SpeedDesguise">00</span>${Speed}`;
			} else if (Speed >= 10 && Speed < 100) {
				Speed = `<span id="SpeedDesguise">0</span>${Speed}`;
			}

			$("#NumSpeed").html(Speed);
			break;

		case "Rpm":
			// var rpmvalue = (event["data"]["Number"] * 18)
			// $(".MarchProgress").css("stroke-dashoffset", (440 - (440 * rpmvalue) / 100));
			$("#Gear").html(event["data"]["Gear"]);
			break;

		// case "Handbrake":
		// 	if (!event["data"]["Status"]) {
		// 		$(".Handbrake").addClass("Gray").removeClass("Red");
		// 	} else {
		// 		$(".Handbrake").addClass("Red").removeClass("Gray");
		// 	}
		// 	break;

		case "Seatbelt":
			if (!event["data"]["Status"]) {
				$(".barOffOnToggle").eq(0).removeClass("ActivedCarIcon");
			} else {
				$(".barOffOnToggle").eq(0).addClass("ActivedCarIcon");
			}
			break;

		// case "Drift":
		// 	if (!event["data"]["Status"]) {
		// 		$(".Drift").addClass("Gray").removeClass("Yellow");
		// 	} else {
		// 		$(".Drift").addClass("Yellow").removeClass("Gray");
		// 	}
		// 	break;

		// case "Headlight":
		// 	if (event["data"]["Status"] == 0) {
		// 		$(".Headlight").addClass("Gray").removeClass("Green").removeClass("Blue");
		// 	} else {
		// 		if (event["data"]["Beam"] == 0) {
		// 			$(".Headlight").addClass("Green").removeClass("Gray").removeClass("Blue");
		// 		} else {
		// 			$(".Headlight").addClass("Blue").removeClass("Gray").removeClass("Green");
		// 		}
		// 	}
		// 	break;

		case "Locked":
			if (event["data"]["Status"] == 2) {
				$(".barOffOnToggle").eq(1).addClass("ActivedCarIcon");
			} else {
				$(".barOffOnToggle").eq(1).removeClass("ActivedCarIcon");
			}
			break;

		// case "Tyres":
		// 	if (event["data"]["Number"] == 0) {
		// 		$(".Tyres").addClass("Gray").removeClass("Yellow").removeClass("Red");
		// 	} else if (event["data"]["Number"] == 1) {
		// 		$(".Tyres").addClass("Yellow").removeClass("Gray").removeClass("Red");
		// 	} else if (event["data"]["Number"] >= 2) {
		// 		$(".Tyres").addClass("Red").removeClass("Gray").removeClass("Yellow");
		// 	}
		// 	break;

		case "Engine":
			var engine = event["data"]["Number"] / 10;
			engine = engine.toFixed(0);
			$("#EngineHealth").html(engine + "%");
			if (engine > 70) {
				$(".barOffOnToggle").eq(2).removeClass("MediumEgineCarIcon");
				$(".barOffOnToggle").eq(2).removeClass("LowEgineCarIcon");

				$(".barOffOnToggle").eq(2).addClass("ActivedCarIcon");
			} else if (engine > 40) {
				$(".barOffOnToggle").eq(2).removeClass("ActivedCarIcon");
				$(".barOffOnToggle").eq(2).removeClass("LowEgineCarIcon");

				$(".barOffOnToggle").eq(2).addClass("MediumEgineCarIcon");
			} else {
				$(".barOffOnToggle").eq(2).removeClass("MediumEgineCarIcon");
				$(".barOffOnToggle").eq(2).removeClass("ActivedCarIcon");

				$(".barOffOnToggle").eq(2).addClass("LowEgineCarIcon");
			}
			break;

		case "Nitro":
			event["data"]["Number"] = event["data"]["Number"] / 20
			$("#NitroFill3").css("width", event["data"]["Number"] + "%");
			$("#NitroFill4").css("width", event["data"]["Number"] + "%");
			break;

		case "Weapons":
			if (event["data"]["Status"]) {
				if ($("#WeaponsInfo").css("display") === "none") {
					$("#WeaponsInfo").fadeIn(timeTransition);
				}

				$("#NameWeapon").html(event["data"]["Name"]);
				$("#MinBullets").html(event["data"]["Min"]);
				$("#MaxBullets").html(event["data"]["Max"]);
			} else {
				if ($("#WeaponsInfo").css("display") === "block") {
					$("#WeaponsInfo").fadeOut(timeTransition);
				}
			}
			break;

		case "Textform":
			if (event["data"]["Mode"] === "Create") {
				var html = `<span id=Textform-${event["data"]["Number"]} class="Textform" style="left: 0; top: 0;"></span>`;
				$(html).fadeIn("normal").appendTo("#Textform");
			} else if (event["data"]["Mode"] === "Update") {
				$("#Textform-" + event["data"]["Number"]).css("left", event["data"]["x"] * 100 + "%").css("top", event["data"]["y"] * 100 + "%");
				$("#Textform-" + event["data"]["Number"]).html(event["data"]["Text"])
			} else if (event["data"]["Mode"] === "Remove") {
				$("#Textform-" + event["data"]["Number"]).fadeOut("normal", function () { $(this).remove(); });
			}
			break;
	}
});