CREATE TABLE "coach" (
    "coachid" SERIAL NOT NULL,
    "firstname" VARCHAR(50) NOT NULL,
    "lastname" VARCHAR(50) NOT NULL,
    "isactive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "coach_pkey" PRIMARY KEY ("coachid")
);

CREATE TABLE "match" (
    "matchid" SERIAL NOT NULL,
    "hometeamid" INTEGER NOT NULL,
    "awayteamid" INTEGER NOT NULL,
    "venueid" INTEGER,
    "matchdate" DATE NOT NULL,

    CONSTRAINT "match_pkey" PRIMARY KEY ("matchid")
);

CREATE TABLE "matchset" (
    "setid" SERIAL NOT NULL,
    "matchid" INTEGER NOT NULL,
    "setnumber" INTEGER,
    "homescore" INTEGER,
    "awayscore" INTEGER,

    CONSTRAINT "matchset_pkey" PRIMARY KEY ("setid")
);

CREATE TABLE "player" (
    "playerid" SERIAL NOT NULL,
    "teamid" INTEGER NOT NULL,
    "firstname" VARCHAR(50) NOT NULL,
    "lastname" VARCHAR(50) NOT NULL,
    "position" VARCHAR(50) NOT NULL,

    CONSTRAINT "player_pkey" PRIMARY KEY ("playerid")
);

CREATE TABLE "playermatchstat" (
    "statid" SERIAL NOT NULL,
    "playerid" INTEGER NOT NULL,
    "matchid" INTEGER NOT NULL,
    "pointsscored" INTEGER DEFAULT 0,

    CONSTRAINT "playermatchstat_pkey" PRIMARY KEY ("statid")
);

CREATE TABLE "playerphones" (
    "phoneid" SERIAL NOT NULL,
    "playerid" INTEGER NOT NULL,
    "phonenumber" VARCHAR(20) NOT NULL,

    CONSTRAINT "playerphones_pkey" PRIMARY KEY ("phoneid")
);

CREATE TABLE "team" (
    "teamid" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "coachid" INTEGER,

    CONSTRAINT "team_pkey" PRIMARY KEY ("teamid")
);

CREATE TABLE "venue" (
    "venueid" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "city" VARCHAR(100) NOT NULL,

    CONSTRAINT "venue_pkey" PRIMARY KEY ("venueid")

CREATE TABLE "award" (
    "awardid" SERIAL NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "year" INTEGER NOT NULL,
    "playerid" INTEGER NOT NULL,

    CONSTRAINT "award_pkey" PRIMARY KEY ("awardid")

CREATE UNIQUE INDEX "matchset_matchid_setnumber_key" ON "matchset"("matchid", "setnumber");

CREATE UNIQUE INDEX "playermatchstat_playerid_matchid_key" ON "playermatchstat"("playerid", "matchid");

CREATE UNIQUE INDEX "team_name_key" ON "team"("name");

ALTER TABLE "match" ADD CONSTRAINT "match_venueid_fkey" FOREIGN KEY ("venueid") REFERENCES "venue"("venueid") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "matchset" ADD CONSTRAINT "matchset_matchid_fkey" FOREIGN KEY ("matchid") REFERENCES "match"("matchid") ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE "player" ADD CONSTRAINT "player_teamid_fkey" FOREIGN KEY ("teamid") REFERENCES "team"("teamid") ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE "playermatchstat" ADD CONSTRAINT "playermatchstat_playerid_fkey" FOREIGN KEY ("playerid") REFERENCES "player"("playerid") ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE "playerphones" ADD CONSTRAINT "playerphones_playerid_fkey" FOREIGN KEY ("playerid") REFERENCES "player"("playerid") ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE "team" ADD CONSTRAINT "team_coachid_fkey" FOREIGN KEY ("coachid") REFERENCES "coach"("coachid") ON DELETE SET NULL ON UPDATE NO ACTION;

ALTER TABLE "award" ADD CONSTRAINT "award_playerid_fkey" FOREIGN KEY ("playerid") REFERENCES "player"("playerid") ON DELETE CASCADE ON UPDATE NO ACTION;
