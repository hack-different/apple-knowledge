# Threat Modeling macOS

## Continued Usage of Encryption for Security Critical Code

I had hoped that iBoot and sepOS on the Mac would no longer be encrypted,
as this is the largest security risk to the platform.  Intel based computers
have EFI which not only has reference source code, but is stored in the clear.
This explicitly makes it impossible to reason about the early boot process and
therefore we rely on Apple's marketing claims about the security of the device.

How many years of low level boot exploits could have been avoided had this code
not been inaccessible for review.

## The massive lack of technical documentation

The Apple security ecosystem is a bizarre dichotomy.  While they are at the forefront
of innovation in the space of platform and silicon security, the complete lack of
documentation prevents IT, Security Professionals and End Users from knowing what
components exist, what their settings are, and what normal expected behavior and
values are.  This repository is an attempt to close that gap, but is a bandage
as this documentation should be published authoritatively by Apple themselves.

The platform security document is marketing fluff, it lacks any detail of where
the measures are implemented (barring the limited documentation of local policy
values).  Greater effort should be made for Apple to document every IMG4 tag,
and file format used in the security model.

Furthermore, each component in the restore process should have a technical
description of what it is.  Yonkers, and Savage for example are still not
well understood.

## Factory, Developer and AppleInternal "Magic"

Discussed separately in [Factory_Threat_Model.md].

## The downgrade of the recoveryOS Policy

Because the paired recoveryOS is also a policy file on disk, it is capable of the same
kinds of `lpol` reductions to `asmb` (Apple Secure Multi Boot).  Most of which target an
as of yet undocumented `smb5` value.

## Failure to Reset `boot-policy-digests`, `xART` and `nonce-seeds` between installs

The integrity of the operating system in an erase is more then just placing the bits on disk.
Due to the fact that local policy, the Owner Identity Key, the System Identity Key and the
User Identity Key are all backed by the SEP, should the ART not be rolled, older policies
can be placed back onto disk.  This is epically true as the recovery environment is not
prevented from placing `com.apple.System.boot-nonces` directly.

## No Consideration of Forensics for Devices

Apple has made no efforts to allow the audit of a device.  The reading of the APTicket,
system firmware, SysCfg, and non-Data partitions should be permitted to be able to
both detect, and resolve malware in the ecosystem.  It is difficult to understand how
we are to accept Apple's marketing around privacy and security, without any capacity
to verify those claims.  Exposure of this data (which is already in IPSWs predominantly,
and per Apple's own claims, the system's security is not contingent on the confidentiality
of this data).  I will note that Apple has recently made strides in the regard bringing
a stripped down version of MRI (Mobile Resource Inspector) to consumers.  This should be
expanded to be far more comprehensive and detailed.

## The Mysterious Power of "Diagnostics"

It's know that booting `diags` provides great power that goes above and outside of the
normal boot process.  Apple also has "remote diagnostics" via the cloud.  Again,
while branded better, its effectively a powerful backdoor.

## Re-entrant Bootloaders

There's no technical measure preventing `fuOS` from in fact booting into iBoot / macOS.
This means that with a proper local policy, inserting into the boot chain becomes possible.

## Broken Initial Trust via `trustobject`, root certificates, etc

If the FDR process has a valid ticket for a `trst` object that is tampered, or that contains
`trPk` entries, it requires factory based booting to remove such objects.

## Stuck in Upgrade

If someone is able to perform an EoP out from the SoftwareUpdate Brain, it can fairly trivially
boot into the window manager and emulate a normal mode boot.  There is no obvious means to
measure or detect this.  As another aside, there's little to no protection for the recovery
APTickets being persisted to disk and used for local boot long term.

## Withholding parts of the restore, or using unusual settings like `UID_MODE`

By refusing to provide all the components of the recovery flow, portions of privilege can
be kept.  First and foremost is the withholding of certificates, NVMe calibration (preventing
the volumes from being cleared), one such observation is missing `eCfg` values in FDR.

## The use of Rosetta to modify binaries and retain system privilege

Because Rosetta can retain entitlements during translation, it becomes a valuable target
for an attacker to pre-poison the AoT cache with malicious translations.  This is particularly
scary when done to core dylibs that provide the syscall interface, leaving a gap between the
observed system and the true system.

## The leveraging of kernel "personas"

The ability for a single use to have multiple personas, leaves the ability for an attacker to
be able to use this to hide parts of the system from a user.

## Leveraging RemoteXPC, and `remotectl` to move services to an AppleVirtualDevice

RemoteXPC was used to allow the Intel processor to communicate to the T2 and bridgeOS.
It provided near seamless `launchd` services that were able to provide XPC interfaces
either between processes on the same CPU, or between CPUs connected via a private
network interface.

## The Usage of `/Library/Apple`

In my observation, this directory which resides in the `Data` volume is treated as though it
is part of the immutable Signed System Volume.  Contents are as follows:

```
├── Library
│ └── Bundles
│     ├── CompatibilityNotificationData.bundle
│     │ └── Contents
│     │     ├── Info.plist
│     │     ├── Resources
│     │     │ ├── CompatibilityNotificationData.plist
│     │     │ ├── Localizable.loctable
│     │     │ ├── ar.lproj
│     │     │ ├── ca.lproj
│     │     │ ├── cs.lproj
│     │     │ ├── da.lproj
│     │     │ ├── de.lproj
│     │     │ ├── el.lproj
│     │     │ ├── en.lproj
│     │     │ ├── en_AU.lproj
│     │     │ ├── en_GB.lproj
│     │     │ ├── es.lproj
│     │     │ ├── es_419.lproj
│     │     │ ├── fi.lproj
│     │     │ ├── fr.lproj
│     │     │ ├── fr_CA.lproj
│     │     │ ├── he.lproj
│     │     │ ├── hi.lproj
│     │     │ ├── hr.lproj
│     │     │ ├── hu.lproj
│     │     │ ├── id.lproj
│     │     │ ├── it.lproj
│     │     │ ├── ja.lproj
│     │     │ ├── ko.lproj
│     │     │ ├── ms.lproj
│     │     │ ├── nl.lproj
│     │     │ ├── no.lproj
│     │     │ ├── pl.lproj
│     │     │ ├── pt_BR.lproj
│     │     │ ├── pt_PT.lproj
│     │     │ ├── ro.lproj
│     │     │ ├── ru.lproj
│     │     │ ├── sk.lproj
│     │     │ ├── sv.lproj
│     │     │ ├── th.lproj
│     │     │ ├── tr.lproj
│     │     │ ├── uk.lproj
│     │     │ ├── vi.lproj
│     │     │ ├── zh_CN.lproj
│     │     │ ├── zh_HK.lproj
│     │     │ └── zh_TW.lproj
│     │     ├── _CodeSignature
│     │     │ ├── CodeDirectory
│     │     │ ├── CodeRequirements
│     │     │ ├── CodeResources
│     │     │ └── CodeSignature
│     │     └── version.plist
│     ├── IncompatibleAppsList.bundle
│     │ └── Contents
│     │     ├── Info.plist
│     │     ├── Resources
│     │     │ ├── IncompatibleAppsList.loctable
│     │     │ ├── IncompatibleAppsList.plist
│     │     │ ├── ar.lproj
│     │     │ ├── ca.lproj
│     │     │ ├── cs.lproj
│     │     │ ├── da.lproj
│     │     │ ├── de.lproj
│     │     │ ├── el.lproj
│     │     │ ├── en.lproj
│     │     │ ├── en_AU.lproj
│     │     │ ├── en_GB.lproj
│     │     │ ├── es.lproj
│     │     │ ├── es_419.lproj
│     │     │ ├── fi.lproj
│     │     │ ├── fr.lproj
│     │     │ ├── fr_CA.lproj
│     │     │ ├── he.lproj
│     │     │ ├── hi.lproj
│     │     │ ├── hr.lproj
│     │     │ ├── hu.lproj
│     │     │ ├── id.lproj
│     │     │ ├── it.lproj
│     │     │ ├── ja.lproj
│     │     │ ├── ko.lproj
│     │     │ ├── ms.lproj
│     │     │ ├── nl.lproj
│     │     │ ├── no.lproj
│     │     │ ├── pl.lproj
│     │     │ ├── pt_BR.lproj
│     │     │ ├── pt_PT.lproj
│     │     │ ├── ro.lproj
│     │     │ ├── ru.lproj
│     │     │ ├── sk.lproj
│     │     │ ├── sv.lproj
│     │     │ ├── th.lproj
│     │     │ ├── tr.lproj
│     │     │ ├── uk.lproj
│     │     │ ├── vi.lproj
│     │     │ ├── zh_CN.lproj
│     │     │ ├── zh_HK.lproj
│     │     │ └── zh_TW.lproj
│     │     ├── _CodeSignature
│     │     │ ├── CodeDirectory
│     │     │ ├── CodeRequirements
│     │     │ ├── CodeResources
│     │     │ └── CodeSignature
│     │     └── version.plist
│     ├── InputAlternatives.bundle
│     │ └── Contents
│     │     ├── Info.plist
│     │     ├── Resources
│     │     │ ├── 4x4OffroadDesertRally.plist
│     │     │ ├── JetSkiWaveRally.plist
│     │     │ ├── Real.slots.casino.saga.classic.plist
│     │     │ ├── antistress.ball.diy.plist
│     │     │ ├── basketball.dunk.ball.haoqiangapp.plist
│     │     │ ├── blue.hero.tuexxyx.bsk.plist
│     │     │ ├── br.com.tapps.moneytree.plist
│     │     │ ├── bussimulator2015.plist
│     │     │ ├── bwebmedia.cooking.game.world.best.recipe.plist
│     │     │ ├── bwebmedia.yummy.pizza.cooking.games.plist
│     │     │ ├── car.moto.bike.guxinyu.plist
│     │     │ ├── cn.iduoduo.RedBall3.plist
│     │     │ ├── co.Northplay.Norse.plist
│     │     │ ├── com.2048game.2048.plist
│     │     │ ├── com.Atinon.PassOver.plist
│     │     │ ├── com.BasicallyGames.BaldisBasicsClassic.plist
│     │     │ ├── com.Carson.RollerCoaster.plist
│     │     │ ├── com.ChillyRoom.DungeonShooter.plist
│     │     │ ├── com.FDGEntertainment.BananaKongBlast.ios.plist
│     │     │ ├── com.Highscoregames.Findout.plist
│     │     │ ├── com.JaddZayed.FillShape3D.plist
│     │     │ ├── com.Jump.Roll.plist
│     │     │ ├── com.LitGames.Amour.plist
│     │     │ ├── com.MAD.GladiatorArena.SwordFighting.plist
│     │     │ ├── com.MobileGamesPro.Battle3D.plist
│     │     │ ├── com.NeufOctobre.BuMyBunnyVirtualPet.plist
│     │     │ ├── com.NikSanTech.FireDots3D.plist
│     │     │ ├── com.PabloLeban.IdleSlayer.plist
│     │     │ ├── com.Pulsar.GrandTruckSimulator.plist
│     │     │ ├── com.RK.BikesHill.plist
│     │     │ ├── com.Rovakhio.GoldRushExpansion.plist
│     │     │ ├── com.ShondurasInc.AdleysPlaySpace.plist
│     │     │ ├── com.SkisoSoft.CargoTransportSimulator.plist
│     │     │ ├── com.Sora.fightingfrog.plist
│     │     │ ├── com.Sora.gangfight.plist
│     │     │ ├── com.abc.carparking.game3d.plist
│     │     │ ├── com.abi.craft.imposter.plist
│     │     │ ├── com.abi.galaxy.invader.alienshooter.plist
│     │     │ ├── com.abi.pixelshooter.blockcraft.zombie.plist
│     │     │ ├── com.acidcousins.fdunk.plist
│     │     │ ├── com.aim.stunts.plist
│     │     │ ├── com.akbari.aquapark.plist
│     │     │ ├── com.akbari.paper.io3d.plist
│     │     │ ├── com.alliancethegame.alliance.airwar.plist
│     │     │ ├── com.almustaphanet.grannysantamid.plist
│     │     │ ├── com.alphapotato.pawnshopmaster.plist
│     │     │ ├── com.amanotes.pamacolorhop.plist
│     │     │ ├── com.amanotes.pamadancingroad.plist
│     │     │ ├── com.amanotes.pamarollingtiles2.plist
│     │     │ ├── com.anderk.wheelscale.plist
│     │     │ ├── com.ankama.dragnboom.plist
│     │     │ ├── com.ansangha.drparking4.plist
│     │     │ ├── com.appatrix.hair.salon.cut.sim.plist
│     │     │ ├── com.appsoleut.realcar.parking.plist
│     │     │ ├── com.apptist.luckyroulette.plist
│     │     │ ├── com.ardev.pastrychef.plist
│     │     │ ├── com.as.babysim.plist
│     │     │ ├── com.asphaltcrackstudio.heavy.excavator.sim.plist
│     │     │ ├── com.astragon.cs3lite.plist
│     │     │ ├── com.at.anime.schoolgirl.plist
│     │     │ ├── com.auxbrain.egginc.plist
│     │     │ ├── com.azurgames.FullMetalMonsters.plist
│     │     │ ├── com.azurgames.stackball.plist
│     │     │ ├── com.balls.JumpBall.plist
│     │     │ ├── com.banditmovie.slotsofvegas.plist
│     │     │ ├── com.batteryacid.highwayrider.plist
│     │     │ ├── com.battleon.aq3d.plist
│     │     │ ├── com.bbtv.odd1sout.plist
│     │     │ ├── com.bearbit.srw2.plist
│     │     │ ├── com.biceps.gtdriver.plist
│     │     │ ├── com.bike.jump.plist
│     │     │ ├── com.bikestunt.megaramp.-021.plist
│     │     │ ├── com.bitmango.ap.blocktrianglepuzzletangram.plist
│     │     │ ├── com.bitmango.ap.bubblepop.plist
│     │     │ ├── com.bitmango.ap.lollipopmatch3.plist
│     │     │ ├── com.blockpuzzle.woodpuzzle.plist
│     │     │ ├── com.bluebook.bigbattle3d.plist
│     │     │ ├── com.brainjourney.plist
│     │     │ ├── com.btstudios.2048solitaire.plist
│     │     │ ├── com.bufeiniao.snake.plist
│     │     │ ├── com.bycodec.projectoffroad20.plist
│     │     │ ├── com.car.chase3d.plist
│     │     │ ├── com.carson.idleracingtycoon.plist
│     │     │ ├── com.carx-tech.demo.plist
│     │     │ ├── com.casino.games.buffalo.slots.plist
│     │     │ ├── com.cassette.aquapark.plist
│     │     │ ├── com.casual.stairwaytoheaven.plist
│     │     │ ├── com.catchallthethief3d.game.plist
│     │     │ ├── com.chateaustudios.sanicdash.plist
│     │     │ ├── com.cherrypiestudio.alias.plist
│     │     │ ├── com.chillingo.perfectkick.plist
│     │     │ ├── com.clement.ballmayhem.plist
│     │     │ ├── com.cmplay.dancingline.plist
│     │     │ ├── com.codigames.idle.airport.tycoon.plist
│     │     │ ├── com.codigames.idle.cooking.tycoon.plist
│     │     │ ├── com.colorfultails.KetchupMaster.plist
│     │     │ ├── com.colorswitch.switch2.plist
│     │     │ ├── com.colorup.game.plist
│     │     │ ├── com.cookapps.ff.luxuryinteriors.plist
│     │     │ ├── com.court.guilty.plist
│     │     │ ├── com.craft.grand.exploration.ios.plist
│     │     │ ├── com.crossfield.badminton.plist
│     │     │ ├── com.cshit.attle.plist
│     │     │ ├── com.ction.4playergames.plist
│     │     │ ├── com.cuongpham.bombermanclassic.plist
│     │     │ ├── com.cvigames.mudrally.plist
│     │     │ ├── com.denizkocoglu.faby.plist
│     │     │ ├── com.derwinstudio.golforbit.plist
│     │     │ ├── com.devgame.ecats.kids.emergency.doctor.hospital.dentist.plist
│     │     │ ├── com.devgame.fixiesfactory.plist
│     │     │ ├── com.distinctivegames.arcadehockey21.plist
│     │     │ ├── com.dodreams.crashonwheels.plist
│     │     │ ├── com.doublefun.idlestickman.plist
│     │     │ ├── com.doublefun.skateart3d.plist
│     │     │ ├── com.dressupone.funmouthdoctor.plist
│     │     │ ├── com.driftwood.cannonbowl.free.plist
│     │     │ ├── com.drinkotron.doubles.plist
│     │     │ ├── com.dvbgames.catsim.plist
│     │     │ ├── com.dvbgames.wildcraft.plist
│     │     │ ├── com.echowall.fancyloves.plist
│     │     │ ├── com.ecotorquegames.impulsegp.plist
│     │     │ ├── com.effectmatrix.cubemator.plist
│     │     │ ├── com.egco.speedracing.bebee.plist
│     │     │ ├── com.eightsec.HumanPuzzle.plist
│     │     │ ├── com.eightsec.JumpRace.plist
│     │     │ ├── com.espnra.GirlBoyAdventure.plist
│     │     │ ├── com.extremesoftbilisim.flyingcarfree.extremepilot2.plist
│     │     │ ├── com.fatunicorn.satisfying.game.plist
│     │     │ ├── com.fc2.web.fujicubesoft.ManyBricksBreaker.plist
│     │     │ ├── com.feelingtouch.zfsd.plist
│     │     │ ├── com.filesstudio.virtualmom.happyfamily.care.plist
│     │     │ ├── com.fingersoft.hillclimbracing.plist
│     │     │ ├── com.fire.game.GoldMiner-Free.plist
│     │     │ ├── com.flamingogamestudio.basketballlife3d.plist
│     │     │ ├── com.flamingogamestudio.parentlife3d.plist
│     │     │ ├── com.flerogames.ios.abyssworld.plist
│     │     │ ├── com.fog.badgranny.plist
│     │     │ ├── com.fullfat.crashlanding.plist
│     │     │ ├── com.funstage.gta.ma.bookofradeluxe.plist
│     │     │ ├── com.game.blockslidergame-ios.plist
│     │     │ ├── com.game.colorslime.plist
│     │     │ ├── com.game.perfectwax3d.plist
│     │     │ ├── com.game.space.shooter2.plist
│     │     │ ├── com.gamehivecorp.beattheboss4.plist
│     │     │ ├── com.gamehivecorp.beattheboss5.plist
│     │     │ ├── com.gamehivecorp.kicktheboss2.plist
│     │     │ ├── com.gameloft.bia3.plist
│     │     │ ├── com.gameloft.iceageadventures.plist
│     │     │ ├── com.games.bottle.plist
│     │     │ ├── com.games.casino.slotsroyale.plist
│     │     │ ├── com.gamesdriving.gotostreet2.plist
│     │     │ ├── com.gamestart.dodgeaction3d.plist
│     │     │ ├── com.gamestart.domino.plist
│     │     │ ├── com.gamestart.riser.plist
│     │     │ ├── com.gamestart.survival.plist
│     │     │ ├── com.gangter.avenger.bullet.rush.plist
│     │     │ ├── com.gencsadiku.carshift.plist
│     │     │ ├── com.germanicus.cmioo.plist
│     │     │ ├── com.ggs.gangsterwarmafiahero.plist
│     │     │ ├── com.giants-software.fs2014.plist
│     │     │ ├── com.gigabitgames.offroad.plist
│     │     │ ├── com.gjg.colorfill3d.plist
│     │     │ ├── com.gogogame.hungrywarn.plist
│     │     │ ├── com.goldstorm.casino.ios.plist
│     │     │ ├── com.goodgamestudios.empirefourkingdoms.plist
│     │     │ ├── com.gtracegames.flyingcarfree.extremepilot.plist
│     │     │ ├── com.gtracegames.flyingdragonsimulatorfiredrake.plist
│     │     │ ├── com.guistudios.advance.car.parking.car.driver.simulator.plist
│     │     │ ├── com.h8games.falldown.plist
│     │     │ ├── com.ha.citypolice.plist
│     │     │ ├── com.hallofplay.it.idle.timbermill.plist
│     │     │ ├── com.hambastudio.linecolor.plist
│     │     │ ├── com.happy.jgfk.plist
│     │     │ ├── com.heuer.RealCarParkingMaster.plist
│     │     │ ├── com.hipsterwhale.crossy.plist
│     │     │ ├── com.hitcents.stickmanepicfree.plist
│     │     │ ├── com.honeyponey.catjump.plist
│     │     │ ├── com.hugogames.arnold.plist
│     │     │ ├── com.huuuge.casino.texas.plist
│     │     │ ├── com.iabuzz.HelloKittyRacingAdventure.plist
│     │     │ ├── com.idle.success.plist
│     │     │ ├── com.idle.treecity.plist
│     │     │ ├── com.idlegalaxy.ios.plist
│     │     │ ├── com.iewagaicho.paintthecube.plist
│     │     │ ├── com.impp.offroad.monsterbus.racing.plist
│     │     │ ├── com.infiltration.game.plist
│     │     │ ├── com.infinityvector.assolutoracing.plist
│     │     │ ├── com.innersloth.amongus.plist
│     │     │ ├── com.inthegame.buildcraftexploration.plist
│     │     │ ├── com.itchmedia.mfp18.plist
│     │     │ ├── com.itchmedia.ta3.plist
│     │     │ ├── com.ivylyoo.runrtalkingcat.plist
│     │     │ ├── com.jackpot.fever.slots.ios.plist
│     │     │ ├── com.jds.binr.plist
│     │     │ ├── com.joycity.blessmobileglobal.plist
│     │     │ ├── com.joygo.gangbrawl.plist
│     │     │ ├── com.keplerians.evilnun2ww.plist
│     │     │ ├── com.keplerians.icescream.plist
│     │     │ ├── com.keplerians.icescreamtwo.plist
│     │     │ ├── com.keplerians.thenun.plist
│     │     │ ├── com.ketchapp.2048bricks.plist
│     │     │ ├── com.ketchapp.artblitz.plist
│     │     │ ├── com.ketchapp.bitcoin.plist
│     │     │ ├── com.ketchapp.donttouchthespikes.plist
│     │     │ ├── com.ketchapp.drawadventures.plist
│     │     │ ├── com.ketchapp.fingerspinner.plist
│     │     │ ├── com.ketchapp.flippyrace.plist
│     │     │ ├── com.ketchapp.horizon.plist
│     │     │ ├── com.ketchapp.jellyjump.plist
│     │     │ ├── com.ketchapp.knifehit.plist
│     │     │ ├── com.ketchapp.stack.plist
│     │     │ ├── com.kitkagames.fallbuddies.plist
│     │     │ ├── com.kooltoucan.DrawScoop.plist
│     │     │ ├── com.kumagames.highschoolsimulator2018.plist
│     │     │ ├── com.kwalee.drawit.plist
│     │     │ ├── com.kwalee.jetpackjump.plist
│     │     │ ├── com.lawson.poke.plist
│     │     │ ├── com.led.lagame.plist
│     │     │ ├── com.legend.strike.online.plist
│     │     │ ├── com.limasky.doodlejumpcsfree.plist
│     │     │ ├── com.limasky.doodlejumpes.plist
│     │     │ ├── com.limasky.doodlejumpipad.plist
│     │     │ ├── com.limasky.doodlejumpipadfree.plist
│     │     │ ├── com.limasky.doodlejumprace.plist
│     │     │ ├── com.lsz.animalfight.plist
│     │     │ ├── com.lunime.gachaclub.plist
│     │     │ ├── com.lunime.gachalife.plist
│     │     │ ├── com.lvlapp.gangster.tps.auto.city.plist
│     │     │ ├── com.magisterapp.dirtyfarm.plist
│     │     │ ├── com.maltd.petsimulator.plist
│     │     │ ├── com.manababa.BeggarKing2.plist
│     │     │ ├── com.manababa.beggarTycoon.plist
│     │     │ ├── com.mars.avgchapters.plist
│     │     │ ├── com.mashentertainment.beamdrive.carcrashsimulator.plist
│     │     │ ├── com.mashentertainment.carcrash.beamdriving.simulator.plist
│     │     │ ├── com.mashentertainment.carcrashdriving.leapofdeath.plist
│     │     │ ├── com.masomo.headball2.plist
│     │     │ ├── com.matchrella.bellavilla.plist
│     │     │ ├── com.mediocre.smashhit.plist
│     │     │ ├── com.meg.car.jumping.plist
│     │     │ ├── com.mgc.runnergame.plist
│     │     │ ├── com.mgrigorov.3dShooter.plist
│     │     │ ├── com.mindy.grap1.plist
│     │     │ ├── com.mkarpenko.worldbox.plist
│     │     │ ├── com.mobile-softing.coinmaster.plist
│     │     │ ├── com.mobilityware.MahjongSolitaire.plist
│     │     │ ├── com.mobirix.airhockey.plist
│     │     │ ├── com.mobirix.jp.bubblebobble1.plist
│     │     │ ├── com.mobisoft.impostor.plist
│     │     │ ├── com.modulesden.highwaytraffic.plist
│     │     │ ├── com.motionvolt.fliprunner.plist
│     │     │ ├── com.motorbike.bikestunts.plist
│     │     │ ├── com.movingstudio.ilikebeingwithyou.plist
│     │     │ ├── com.mpmf.jetcar3d.plist
│     │     │ ├── com.my.evolution2.plist
│     │     │ ├── com.namconetworks.pacmanlite.plist
│     │     │ ├── com.nanobitsoftware.mystory.plist
│     │     │ ├── com.nanobitsoftware.taboo.plist
│     │     │ ├── com.neonfun.catalog.plist
│     │     │ ├── com.neonplay.casualidletapstrongman.plist
│     │     │ ├── com.nevosoft.mylittleplanet.plist
│     │     │ ├── com.newstargames.retrobowl.plist
│     │     │ ├── com.nextepisode.roperescue.plist
│     │     │ ├── com.nguyenvh.holeio.plist
│     │     │ ├── com.nimblebit.discozoo.plist
│     │     │ ├── com.nitrome.magictouch.plist
│     │     │ ├── com.noodlecake.happyjump.plist
│     │     │ ├── com.nope.SmashHeroes.plist
│     │     │ ├── com.nopowerup.idleaquapark.plist
│     │     │ ├── com.nopowerup.idlelightcity.plist
│     │     │ ├── com.noxgroup.game.eggfinder.ios.plist
│     │     │ ├── com.nway.wweundisputed.plist
│     │     │ ├── com.ohmgames.cheatandrun.plist
│     │     │ ├── com.oneway.Deathcoming.plist
│     │     │ ├── com.orangenose.tablefull.plist
│     │     │ ├── com.orbitalknight.castlewreck.plist
│     │     │ ├── com.orbitalknight.forcemaster.plist
│     │     │ ├── com.outfit7.talkingtomgoldrun.plist
│     │     │ ├── com.ouwant.2048.plist
│     │     │ ├── com.ovilex.realdriving3d.plist
│     │     │ ├── com.ovilex.trucksimulatorusa.plist
│     │     │ ├── com.painter.cutandpaint.plist
│     │     │ ├── com.pazugames.girlshairsalon.plist
│     │     │ ├── com.pazugames.nailsalon.plist
│     │     │ ├── com.pazugames.squishy.plist
│     │     │ ├── com.peoplefun.blocks2.plist
│     │     │ ├── com.peoplefun.wordsearch.plist
│     │     │ ├── com.phanotek.wingsofduty.plist
│     │     │ ├── com.pinpinteam.rockcrawling.plist
│     │     │ ├── com.pixelbox.roofrails.plist
│     │     │ ├── com.playsaurus.clickerheroes.plist
│     │     │ ├── com.playsidestudios.drifty.plist
│     │     │ ├── com.playsidestudios.ice.plist
│     │     │ ├── com.pocapp.dungeondogs.plist
│     │     │ ├── com.pool.club.billiards.city.plist
│     │     │ ├── com.pregnant.mother.games.plist
│     │     │ ├── com.pronetis.ironballride2.plist
│     │     │ ├── com.pronetis.outstrip.plist
│     │     │ ├── com.psmob.kvart2.plist
│     │     │ ├── com.puzzle.game.block.plist
│     │     │ ├── com.qckmob.john.truck.car.transport.driver.2019.plist
│     │     │ ├── com.qjlwar.worldcell.plist
│     │     │ ├── com.quzizi.2048balls.plist
│     │     │ ├── com.racinggame.crazyforspeed.plist
│     │     │ ├── com.redbull.bike2.plist
│     │     │ ├── com.redbull.moto.plist
│     │     │ ├── com.redforcegames.stack.colors.plist
│     │     │ ├── com.redzombiegame.ioscn.plist
│     │     │ ├── com.retrodreamer.icecreamjump.plist
│     │     │ ├── com.rizi.grannyischristmas.plist
│     │     │ ├── com.robtop.geometrydashmeltdown.plist
│     │     │ ├── com.rubygames.slingdrift.plist
│     │     │ ├── com.runonetworks.correyseva.plist
│     │     │ ├── com.saevio.fungoal.plist
│     │     │ ├── com.saf.bsr3ah.plist
│     │     │ ├── com.sakkatstudio.brain.plist
│     │     │ ├── com.sb.school.girl.sim.life.plist
│     │     │ ├── com.sdpgames.sculptpeople.plist
│     │     │ ├── com.sebby.carrosrebaixadosonline.plist
│     │     │ ├── com.secretqueen.standoff-case.plist
│     │     │ ├── com.seeplay.catjump.plist
│     │     │ ├── com.senspark.goldminerclassic.plist
│     │     │ ├── com.setsnail.daddylonglegs.plist
│     │     │ ├── com.severine.freerace.plist
│     │     │ ├── com.sevval.DrivingSchoolTestSim2021.plist
│     │     │ ├── com.seyeonsoft.friends.plist
│     │     │ ├── com.shockwavegames.border.patrol.police.simulator.plist
│     │     │ ├── com.shooting.ball.pool.billiards.plist
│     │     │ ├── com.shotgungaming.duckz.plist
│     │     │ ├── com.sinyee.babybus.cube.plist
│     │     │ ├── com.skgames.racer.plist
│     │     │ ├── com.slippy.linerusher.plist
│     │     │ ├── com.sm.dtgt.plist
│     │     │ ├── com.solitatire.merge2048.plist
│     │     │ ├── com.sport.cornhole.plist
│     │     │ ├── com.spungegames.failybrakes.plist
│     │     │ ├── com.stealthaims.spy.man.plist
│     │     │ ├── com.stickman.warriors.stickwarriors.dragon.shadow.fight.plist
│     │     │ ├── com.super.stars.plist
│     │     │ ├── com.tarbooshgames.bungeet.plist
│     │     │ ├── com.tellmewow.senior.pastimes.plist
│     │     │ ├── com.tgc.sky.ios.plist
│     │     │ ├── com.thetisgames.fs2014.universal.free.plist
│     │     │ ├── com.thetisgames.ios.flywingsparis.free.plist
│     │     │ ├── com.thetisgames.ios.grandheistonline2.free.plist
│     │     │ ├── com.tho.casualcooking.plist
│     │     │ ├── com.tintash.nailsalon.plist
│     │     │ ├── com.tivola.doghotel.plist
│     │     │ ├── com.tocapp.airhockeywear.Air-Hockey-Wear.plist
│     │     │ ├── com.topchopgames.skyroller.plist
│     │     │ ├── com.toppluva.grandmountainadventure.plist
│     │     │ ├── com.tp.holidayhome.plist
│     │     │ ├── com.tpg.dad.happy.family.plist
│     │     │ ├── com.tradegame.easyflight.plist
│     │     │ ├── com.trafficmotoracing.xspeedrider.plist
│     │     │ ├── com.trianglegames.squarebird.plist
│     │     │ ├── com.trinitigame.callofminidinohunter.plist
│     │     │ ├── com.trinitigame.callofminizombies.plist
│     │     │ ├── com.trinitigame.callofminizombies2.plist
│     │     │ ├── com.tummygames.pancakeart.plist
│     │     │ ├── com.turbochilli.rollingsky.plist
│     │     │ ├── com.turner.cnplay.plist
│     │     │ ├── com.tutotoons.app.littlekittytown.free.plist
│     │     │ ├── com.twistygames.animalrescue.plist
│     │     │ ├── com.uh.virtual.teacher.plist
│     │     │ ├── com.uqxuwtxbbu.parkingjam.plist
│     │     │ ├── com.vector.free.game.tossup.plist
│     │     │ ├── com.vectorunit.cobalt.plist
│     │     │ ├── com.viradiya.carparking.plist
│     │     │ ├── com.wcs.car.mechanic.engine.overhaul.simulator.plist
│     │     │ ├── com.weegoon.drawpuzzle2onelineonepart.plist
│     │     │ ├── com.wildbeep.dribblehoops.plist
│     │     │ ├── com.wildspike.wormszone.plist
│     │     │ ├── com.winrgames.bigtime.plist
│     │     │ ├── com.wooden.block.puzzle.ultimate.plist
│     │     │ ├── com.worksinc.bakkure2.plist
│     │     │ ├── com.x3m.ispace.plist
│     │     │ ├── com.xiaoyu5195.attackangrymonster.plist
│     │     │ ├── com.xihe.projecta.plist
│     │     │ ├── com.xlegend.aurakingdom2.global.plist
│     │     │ ├── com.xsj.crazyduck.plist
│     │     │ ├── com.yaohua.vegasnights.plist
│     │     │ ├── com.yinyong.blockdash.plist
│     │     │ ├── com.yipkahok.moto.bike.race.plist
│     │     │ ├── com.yolostudio.redimpostor.plist
│     │     │ ├── com.yottagames.gameofmafia.plist
│     │     │ ├── com.yourcompany.DoodleJump.plist
│     │     │ ├── com.zeliogames.computer.plist
│     │     │ ├── com.zeptolab.thieves.plist
│     │     │ ├── com.zuuks.truck.simulator.euro.plist
│     │     │ ├── de.kamibox.bacon.plist
│     │     │ ├── dk.animwork.losttracks.plist
│     │     │ ├── fantasy.survival.game.rpg.plist
│     │     │ ├── firehero.uapub.plist
│     │     │ ├── flow.line.match.master.plist
│     │     │ ├── gg.sunday.catescape.plist
│     │     │ ├── gs.rrh.bc.plist
│     │     │ ├── happy.yuu.com.draw.plist
│     │     │ ├── idle.grasscutter.plist
│     │     │ ├── io.hyperhug.mr.slice.plist
│     │     │ ├── io.voodoo.crowdcity.plist
│     │     │ ├── io.voodoo.dune.plist
│     │     │ ├── io.voodoo.paper2.plist
│     │     │ ├── io.voodoo.paper3.plist
│     │     │ ├── io.voodoo.paperio.plist
│     │     │ ├── ios.steel.slice.cut.asmr.plist
│     │     │ ├── iupx.tastyland.plist
│     │     │ ├── jp.dawn.mirrorcakes.plist
│     │     │ ├── jp.dawn.perfectaluminumball.plist
│     │     │ ├── jp.hibikiyano.kungfuball.plist
│     │     │ ├── jp.usaya.nigenekoen.plist
│     │     │ ├── kr.co.smartstudy.babysharkrun.plist
│     │     │ ├── liza.CarLine.plist
│     │     │ ├── metal.gun.fight.games.coolmelon.plist
│     │     │ ├── mobi.gameguru.racingfever.plist
│     │     │ ├── moto.bike.racing.night.rider.plist
│     │     │ ├── net.mobigame.ZombieCarnaval.plist
│     │     │ ├── net.updategames.granny.plist
│     │     │ ├── ninja.creed.sniper.real3d.action.free.ios.plist
│     │     │ ├── online.limitless.appleknight.free.plist
│     │     │ ├── pampam.ibf2.plist
│     │     │ ├── plant.garden.flower.game.plist
│     │     │ ├── productions.smpl.highrise.plist
│     │     │ ├── puzzle.blockpuzzle.cube.relax.plist
│     │     │ ├── pvp.survival.rpg.fog.plist
│     │     │ ├── race.arena.io.plist
│     │     │ ├── racing.moto.bike.race.huisunlan.plist
│     │     │ ├── ro.Badwolf.ironsuit.plist
│     │     │ ├── ro.xsasoftware.ammericanoffroadoutlaw.plist
│     │     │ ├── ru.DemisMezirov.dive.plist
│     │     │ ├── slots.games.vegas.night.casino.plist
│     │     │ ├── slots.secretsauce.casino.games.free.ios.plist
│     │     │ ├── snake.io.snake.war.fight.plist
│     │     │ ├── super.sharpshooter.gun.gun98k.plist
│     │     │ ├── tr.com.apps.trivia.race.plist
│     │     │ ├── us.kr.baseballnine.plist
│     │     │ ├── vegas.classic.slots.bravo.free.ios.plist
│     │     │ ├── wild.west.sniper.plist
│     │     │ └── www.fishlabs.net.gof2hd.plist
│     │     ├── _CodeSignature
│     │     │ ├── CodeDirectory
│     │     │ ├── CodeRequirements
│     │     │ ├── CodeResources
│     │     │ └── CodeSignature
│     │     └── version.plist
│     └── TCC_Compatibility.bundle
│         └── Contents
│             ├── Info.plist
│             ├── Resources
│             │ └── AllowApplicationsList.plist
│             ├── _CodeSignature
│             │ ├── CodeDirectory
│             │ ├── CodeRequirements
│             │ ├── CodeResources
│             │ └── CodeSignature
│             └── version.plist
├── System
│ └── Library
│     ├── CoreServices
│     │ ├── CoreTypes.bundle
│     │ │ └── Contents
│     │ │     └── Resources
│     │ │         ├── XProtect.meta.plist -> ../../../XProtect.bundle/Contents/Resources/XProtect.meta.plist
│     │ │         └── XProtect.plist -> ../../../XProtect.bundle/Contents/Resources/XProtect.plist
│     │ ├── MRT.app
│     │ │ └── Contents
│     │ │     ├── Frameworks
│     │ │     │ ├── libswiftAppKit.dylib
│     │ │     │ ├── libswiftCore.dylib
│     │ │     │ ├── libswiftCoreData.dylib
│     │ │     │ ├── libswiftCoreFoundation.dylib
│     │ │     │ ├── libswiftCoreGraphics.dylib
│     │ │     │ ├── libswiftCoreImage.dylib
│     │ │     │ ├── libswiftDarwin.dylib
│     │ │     │ ├── libswiftDispatch.dylib
│     │ │     │ ├── libswiftFoundation.dylib
│     │ │     │ ├── libswiftIOKit.dylib
│     │ │     │ ├── libswiftMetal.dylib
│     │ │     │ ├── libswiftObjectiveC.dylib
│     │ │     │ ├── libswiftQuartzCore.dylib
│     │ │     │ ├── libswiftXPC.dylib
│     │ │     │ └── libswiftos.dylib
│     │ │     ├── Info.plist
│     │ │     ├── MacOS
│     │ │     │ ├── MRT
│     │ │     │ └── mrt-helper
│     │ │     ├── PkgInfo
│     │ │     ├── Resources
│     │ │     │ ├── Info.plist
│     │ │     │ ├── ar.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── ca.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── cs.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── da.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── de.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── el.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── en.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── es.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── es_419.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── es_MX.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── fi.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── fr.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── he.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── hi.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── hr.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── hu.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── id.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── it.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── ja.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── ko.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── ms.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── nl.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── no.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── pl.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── pt.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── pt_PT.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── ro.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── ru.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── sk.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── sv.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── th.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── tr.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── uk.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── version.plist
│     │ │     │ ├── vi.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ ├── zh_CN.lproj
│     │ │     │ │ ├── Localizable.strings
│     │ │     │ │ └── locversion.plist
│     │ │     │ └── zh_TW.lproj
│     │ │     │     ├── Localizable.strings
│     │ │     │     └── locversion.plist
│     │ │     ├── _CodeSignature
│     │ │     │ └── CodeResources
│     │ │     └── version.plist
│     │ ├── XProtect.app
│     │ │ └── Contents
│     │ │     ├── Info.plist
│     │ │     ├── MacOS
│     │ │     │ ├── XProtect
│     │ │     │ ├── XProtectRemediatorAdload
│     │ │     │ ├── XProtectRemediatorBadGacha
│     │ │     │ ├── XProtectRemediatorBlueTop
│     │ │     │ ├── XProtectRemediatorCardboardCutout
│     │ │     │ ├── XProtectRemediatorColdSnap
│     │ │     │ ├── XProtectRemediatorCrapyrator
│     │ │     │ ├── XProtectRemediatorDubRobber
│     │ │     │ ├── XProtectRemediatorEicar
│     │ │     │ ├── XProtectRemediatorFloppyFlipper
│     │ │     │ ├── XProtectRemediatorGenieo
│     │ │     │ ├── XProtectRemediatorGreenAcre
│     │ │     │ ├── XProtectRemediatorKeySteal
│     │ │     │ ├── XProtectRemediatorMRTv3
│     │ │     │ ├── XProtectRemediatorPirrit
│     │ │     │ ├── XProtectRemediatorRankStank
│     │ │     │ ├── XProtectRemediatorRedPine
│     │ │     │ ├── XProtectRemediatorRoachFlight
│     │ │     │ ├── XProtectRemediatorSheepSwap
│     │ │     │ ├── XProtectRemediatorSnowBeagle
│     │ │     │ ├── XProtectRemediatorSnowDrift
│     │ │     │ ├── XProtectRemediatorToyDrop
│     │ │     │ ├── XProtectRemediatorTrovi
│     │ │     │ └── XProtectRemediatorWaterNet
│     │ │     ├── PkgInfo
│     │ │     ├── Resources
│     │ │     │ ├── BastionMeta.plist
│     │ │     │ ├── bastion.sb
│     │ │     │ ├── com.apple.XProtect.agent.scan.plist
│     │ │     │ ├── com.apple.XProtect.agent.scan.startup.plist
│     │ │     │ ├── com.apple.XProtect.daemon.scan.plist
│     │ │     │ ├── com.apple.XProtect.daemon.scan.startup.plist
│     │ │     │ ├── com.apple.XprotectFramework.PluginService.plist
│     │ │     │ └── libXProtectPayloads.dylib
│     │ │     ├── XPCServices
│     │ │     │ └── XProtectPluginService.xpc
│     │ │     │     └── Contents
│     │ │     │         ├── Info.plist
│     │ │     │         ├── MacOS
│     │ │     │         │ └── XProtectPluginService
│     │ │     │         ├── _CodeSignature
│     │ │     │         │ └── CodeResources
│     │ │     │         └── version.plist
│     │ │     ├── _CodeSignature
│     │ │     │ └── CodeResources
│     │ │     └── version.plist
│     │ └── XProtect.bundle
│     │     └── Contents
│     │         ├── Info.plist
│     │         ├── Resources
│     │         │ ├── LegacyEntitlementAllowlist.plist
│     │         │ ├── XProtect.meta.plist
│     │         │ ├── XProtect.plist
│     │         │ ├── XProtect.yara
│     │         │ └── gk.db
│     │         ├── _CodeSignature
│     │         │ ├── CodeDirectory
│     │         │ ├── CodeRequirements
│     │         │ ├── CodeRequirements-1
│     │         │ ├── CodeResources
│     │         │ └── CodeSignature
│     │         └── version.plist
│     ├── Extensions
│     │ ├── AppleKextExcludeList.kext
│     │ │ └── Contents
│     │ │     ├── Info.plist
│     │ │     ├── Resources
│     │ │     │ └── ExceptionLists.plist
│     │ │     ├── _CodeSignature
│     │ │     │ ├── CodeDirectory
│     │ │     │ ├── CodeRequirements
│     │ │     │ ├── CodeResources
│     │ │     │ └── CodeSignature
│     │ │     └── version.plist
│     │ └── AppleMobileDevice.kext
│     │     └── Contents
│     │         ├── Info.plist
│     │         ├── _CodeSignature
│     │         │ ├── CodeDirectory
│     │         │ ├── CodeRequirements
│     │         │ ├── CodeResources
│     │         │ └── CodeSignature
│     │         └── version.plist
│     ├── InstallerSandboxes
│     ├── LaunchAgents
│     │ ├── com.apple.MRTa.plist
│     │ ├── com.apple.XProtect.agent.scan.plist -> /Library/Apple/System/Library/CoreServices/XProtect.app//Contents/Resources/com.apple.XProtect.agent.scan.plist
│     │ ├── com.apple.XProtect.agent.scan.startup.plist -> /Library/Apple/System/Library/CoreServices/XProtect.app//Contents/Resources/com.apple.XProtect.agent.scan.startup.plist
│     │ ├── com.apple.XprotectFramework.PluginService.plist -> /Library/Apple/System/Library/CoreServices/XProtect.app//Contents/Resources/com.apple.XprotectFramework.PluginService.plist
│     │ └── com.apple.mobiledeviceupdater.plist
│     ├── LaunchDaemons
│     │ ├── com.apple.MRTd.plist
│     │ ├── com.apple.XProtect.daemon.scan.plist -> /Library/Apple/System/Library/CoreServices/XProtect.app//Contents/Resources/com.apple.XProtect.daemon.scan.plist
│     │ ├── com.apple.XProtect.daemon.scan.startup.plist -> /Library/Apple/System/Library/CoreServices/XProtect.app//Contents/Resources/com.apple.XProtect.daemon.scan.startup.plist
│     │ ├── com.apple.XprotectFramework.PluginService.plist -> /Library/Apple/System/Library/CoreServices/XProtect.app//Contents/Resources/com.apple.XprotectFramework.PluginService.plist
│     │ ├── com.apple.dt.RemotePairingDataVaultHelper.plist
│     │ └── com.apple.usbmuxd.plist
│     ├── PrivateFrameworks
│     │ ├── AirTrafficHost.framework
│     │ │ ├── AirTrafficHost -> Versions/Current/AirTrafficHost
│     │ │ ├── Resources -> Versions/Current/Resources
│     │ │ └── Versions
│     │ │     ├── A
│     │ │     │ ├── AirTrafficHost
│     │ │     │ ├── Resources
│     │ │     │ │ ├── Info.plist
│     │ │     │ │ └── version.plist
│     │ │     │ └── _CodeSignature
│     │ │     │     └── CodeResources
│     │ │     └── Current -> A
│     │ ├── DeviceLink.framework
│     │ │ ├── DeviceLink -> Versions/Current/DeviceLink
│     │ │ ├── Resources -> Versions/Current/Resources
│     │ │ └── Versions
│     │ │     ├── A
│     │ │     │ ├── DeviceLink
│     │ │     │ ├── Resources
│     │ │     │ │ ├── Info.plist
│     │ │     │ │ └── version.plist
│     │ │     │ └── _CodeSignature
│     │ │     │     └── CodeResources
│     │ │     └── Current -> A
│     │ ├── Mercury.framework
│     │ │ ├── Mercury -> Versions/Current/Mercury
│     │ │ ├── Resources -> Versions/Current/Resources
│     │ │ └── Versions
│     │ │     ├── A
│     │ │     │ ├── Mercury
│     │ │     │ ├── Resources
│     │ │     │ │ ├── Info.plist
│     │ │     │ │ └── version.plist
│     │ │     │ └── _CodeSignature
│     │ │     │     └── CodeResources
│     │ │     └── Current -> A
│     │ ├── MobileDevice.framework
│     │ │ ├── MobileDevice -> Versions/Current/MobileDevice
│     │ │ ├── Resources -> Versions/Current/Resources
│     │ │ ├── Versions
│     │ │ │ ├── A
│     │ │ │ │ ├── AppleMobileDeviceHelper.app
│     │ │ │ │ │ └── Contents
│     │ │ │ │ │     ├── Info.plist
│     │ │ │ │ │     ├── MacOS
│     │ │ │ │ │     │ └── AppleMobileDeviceHelper
│     │ │ │ │ │     ├── PkgInfo
│     │ │ │ │ │     ├── Resources
│     │ │ │ │ │     │ ├── AppleMobileBackup
│     │ │ │ │ │     │ ├── ClientDescription.plist
│     │ │ │ │ │     │ ├── ClientDescription20.plist
│     │ │ │ │ │     │ ├── ClientDescription30.plist
│     │ │ │ │ │     │ ├── ClientDescription33.plist
│     │ │ │ │ │     │ ├── ClientDescription33Tiger.plist
│     │ │ │ │ │     │ ├── ClientDescription40.plist
│     │ │ │ │ │     │ ├── ClientDescription40Tiger.plist
│     │ │ │ │ │     │ ├── ClientDescription50.plist
│     │ │ │ │ │     │ ├── ClientDescription50SnowLeopard.plist
│     │ │ │ │ │     │ ├── ClientDescription50Tiger.plist
│     │ │ │ │ │     │ ├── MDCrashReportTool
│     │ │ │ │ │     │ └── iPodSyncClientImages.icns
│     │ │ │ │ │     ├── _CodeSignature
│     │ │ │ │ │     │ └── CodeResources
│     │ │ │ │ │     └── version.plist
│     │ │ │ │ ├── AppleMobileSync.app
│     │ │ │ │ │ └── Contents
│     │ │ │ │ │     ├── Info.plist
│     │ │ │ │ │     ├── MacOS
│     │ │ │ │ │     │ └── AppleMobileSync
│     │ │ │ │ │     ├── PkgInfo
│     │ │ │ │ │     ├── Resources
│     │ │ │ │ │     │ └── iPodSyncClientImages.icns
│     │ │ │ │ │     ├── _CodeSignature
│     │ │ │ │ │     │ └── CodeResources
│     │ │ │ │ │     └── version.plist
│     │ │ │ │ ├── MobileDevice
│     │ │ │ │ ├── Resources
│     │ │ │ │ │ ├── Info.plist
│     │ │ │ │ │ ├── MobileDeviceUpdater.app
│     │ │ │ │ │ │ └── Contents
│     │ │ │ │ │ │     ├── Info.plist
│     │ │ │ │ │ │     ├── MacOS
│     │ │ │ │ │ │     │ └── MobileDeviceUpdater
│     │ │ │ │ │ │     ├── PkgInfo
│     │ │ │ │ │ │     ├── Resources
│     │ │ │ │ │ │     │ ├── Base.lproj
│     │ │ │ │ │ │     │ │ ├── MainMenu.nib
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.nib
│     │ │ │ │ │ │     │ ├── ar.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── ca.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── com.apple.iphone-x-1.icns
│     │ │ │ │ │ │     │ ├── com.apple.mobiledeviceupdater.plist
│     │ │ │ │ │ │     │ ├── cs.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── da.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── de.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── el.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── en.lproj
│     │ │ │ │ │ │     │ │ └── Localizable.strings
│     │ │ │ │ │ │     │ ├── en_AU.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── en_GB.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── es.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── es_419.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── fi.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── fr.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── fr_CA.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── he.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── hi.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── hr.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── hu.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── id.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── it.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── ja.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── ko.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── ms.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── nl.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── no.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── pl.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── pt_BR.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── pt_PT.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── ro.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── ru.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── sk.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── sv.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── th.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── tr.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── uk.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── vi.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── zh_CN.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ ├── zh_HK.lproj
│     │ │ │ │ │ │     │ │ ├── Localizable.strings
│     │ │ │ │ │ │     │ │ ├── MainMenu.strings
│     │ │ │ │ │ │     │ │ └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     │ └── zh_TW.lproj
│     │ │ │ │ │ │     │     ├── Localizable.strings
│     │ │ │ │ │ │     │     ├── MainMenu.strings
│     │ │ │ │ │ │     │     └── MobileDeviceUpdateController.strings
│     │ │ │ │ │ │     ├── _CodeSignature
│     │ │ │ │ │ │     │ └── CodeResources
│     │ │ │ │ │ │     └── version.plist
│     │ │ │ │ │ ├── ar.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── ca.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── cs.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── da.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── de.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── el.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── en.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── en_AU.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── en_GB.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── es.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── es_419.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── fi.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── fr.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── fr_CA.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── he.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── hi.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── hr.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── hu.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── id.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── it.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── ja.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── ko.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── ms.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── nl.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── no.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── pl.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── pt_BR.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── pt_PT.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── ro.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── ru.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── sk.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── sv.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── th.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── tr.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── uk.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── usbmuxd
│     │ │ │ │ │ ├── version.plist
│     │ │ │ │ │ ├── vi.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── zh_CN.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ ├── zh_HK.lproj
│     │ │ │ │ │ │ ├── InfoPlist.strings
│     │ │ │ │ │ │ └── Localizable.strings
│     │ │ │ │ │ └── zh_TW.lproj
│     │ │ │ │ │     ├── InfoPlist.strings
│     │ │ │ │ │     └── Localizable.strings
│     │ │ │ │ ├── XPCServices
│     │ │ │ │ │ ├── MDPrivilegedUSBSupport.xpc
│     │ │ │ │ │ │ └── Contents
│     │ │ │ │ │ │     ├── Info.plist
│     │ │ │ │ │ │     ├── MacOS
│     │ │ │ │ │ │     │ └── MDPrivilegedUSBSupport
│     │ │ │ │ │ │     ├── Resources
│     │ │ │ │ │ │     │ ├── ar.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── ca.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── cs.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── da.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── de.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── el.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── en_AU.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── en_GB.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── es.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── es_419.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── fi.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── fr.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── fr_CA.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── he.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── hi.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── hr.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── hu.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── id.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── it.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── ja.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── ko.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── ms.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── nl.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── no.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── pl.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── pt_BR.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── pt_PT.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── ro.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── ru.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── sk.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── sv.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── th.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── tr.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── uk.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── vi.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── zh_CN.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ ├── zh_HK.lproj
│     │ │ │ │ │ │     │ │ └── InfoPlist.strings
│     │ │ │ │ │ │     │ └── zh_TW.lproj
│     │ │ │ │ │ │     │     └── InfoPlist.strings
│     │ │ │ │ │ │     ├── _CodeSignature
│     │ │ │ │ │ │     │ └── CodeResources
│     │ │ │ │ │ │     └── version.plist
│     │ │ │ │ │ └── MDRemoteServiceSupport.xpc
│     │ │ │ │ │     └── Contents
│     │ │ │ │ │         ├── Info.plist
│     │ │ │ │ │         ├── MacOS
│     │ │ │ │ │         │ └── MDRemoteServiceSupport
│     │ │ │ │ │         ├── Resources
│     │ │ │ │ │         │ ├── ar.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── ca.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── cs.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── da.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── de.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── el.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── en_AU.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── en_GB.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── es.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── es_419.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── fi.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── fr.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── fr_CA.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── he.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── hi.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── hr.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── hu.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── id.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── it.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── ja.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── ko.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── ms.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── nl.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── no.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── pl.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── pt_BR.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── pt_PT.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── ro.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── ru.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── sk.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── sv.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── th.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── tr.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── uk.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── vi.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── zh_CN.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ ├── zh_HK.lproj
│     │ │ │ │ │         │ │ └── InfoPlist.strings
│     │ │ │ │ │         │ └── zh_TW.lproj
│     │ │ │ │ │         │     └── InfoPlist.strings
│     │ │ │ │ │         ├── _CodeSignature
│     │ │ │ │ │         │ └── CodeResources
│     │ │ │ │ │         └── version.plist
│     │ │ │ │ └── _CodeSignature
│     │ │ │ │     └── CodeResources
│     │ │ │ └── Current -> A
│     │ │ └── XPCServices -> Versions/Current/XPCServices
│     │ └── RemotePairing.framework
│     │     ├── RemotePairing -> Versions/Current/RemotePairing
│     │     ├── Resources -> Versions/Current/Resources
│     │     ├── Versions
│     │     │ ├── A
│     │     │ │ ├── RemotePairing
│     │     │ │ ├── Resources
│     │     │ │ │ ├── Info.plist
│     │     │ │ │ ├── bin
│     │     │ │ │ │ └── RemotePairingDataVaultHelper
│     │     │ │ │ └── version.plist
│     │     │ │ ├── XPCServices
│     │     │ │ │ └── remotepairingd.xpc
│     │     │ │ │     └── Contents
│     │     │ │ │         ├── Info.plist
│     │     │ │ │         ├── MacOS
│     │     │ │ │         │ └── remotepairingd
│     │     │ │ │         ├── _CodeSignature
│     │     │ │ │         │ └── CodeResources
│     │     │ │ │         └── version.plist
│     │     │ │ └── _CodeSignature
│     │     │ │     └── CodeResources
│     │     │ └── Current -> A
│     │     └── XPCServices -> Versions/Current/XPCServices
│     └── Receipts
│         ├── com.apple.files.data-template.bom
│         ├── com.apple.files.data-template.plist
│         ├── com.apple.pkg.CLTools_Executables.bom
│         ├── com.apple.pkg.CLTools_Executables.plist
│         ├── com.apple.pkg.CLTools_SDK_macOS13.bom
│         ├── com.apple.pkg.CLTools_SDK_macOS13.plist
│         ├── com.apple.pkg.CLTools_SDK_macOS14.bom
│         ├── com.apple.pkg.CLTools_SDK_macOS14.plist
│         ├── com.apple.pkg.CLTools_SwiftBackDeploy.bom
│         ├── com.apple.pkg.CLTools_SwiftBackDeploy.plist
│         ├── com.apple.pkg.CLTools_macOS_SDK.bom
│         ├── com.apple.pkg.CLTools_macOS_SDK.plist
│         ├── com.apple.pkg.MRTConfigData_10_15.16U4211.bom
│         ├── com.apple.pkg.MRTConfigData_10_15.16U4211.plist
│         ├── com.apple.pkg.RosettaUpdateAuto.bom
│         ├── com.apple.pkg.RosettaUpdateAuto.plist
│         ├── com.apple.pkg.XProtectPayloads_10_15.16U4295.bom
│         ├── com.apple.pkg.XProtectPayloads_10_15.16U4295.plist
│         ├── com.apple.pkg.XProtectPlistConfigData_10_15.16U4296.bom
│         ├── com.apple.pkg.XProtectPlistConfigData_10_15.16U4296.plist
│         ├── com.apple.pkg.XProtectPlistConfigData_10_15.16U4298.bom
│         └── com.apple.pkg.XProtectPlistConfigData_10_15.16U4298.plist
└── usr
    ├── lib
    │ └── libRosettaAot.dylib
    ├── libexec
    │ └── oah
    │     ├── RosettaLinux
    │     │ ├── rosetta
    │     │ └── rosettad
    │     ├── debugserver -> /usr/libexec/rosetta/debugserver
    │     ├── libRosettaRuntime
    │     ├── runtime -> /usr/libexec/rosetta/runtime
    │     └── translate_tool -> /usr/libexec/rosetta/translate_tool
    └── share
        └── rosetta
            └── rosetta
```
