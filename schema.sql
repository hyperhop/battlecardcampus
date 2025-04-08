-- These are the Card Tables
CREATE TABLE "cards" (
    "id" TEXT,
    "name" TEXT NOT NULL,
    "set_id" INTEGER,
    "type" TEXT NOT NULL,
    "rarity" TEXT NOT NULL,
    "battle_points_cost" INTEGER,
    "energy_cost" INTEGER NOT NULL,
    "health_points" INTEGER,
    "attack" INTEGER,
    "defense" INTEGER,
    "ability01" TEXT,
    "ability02" TEXT,
    "ability03" TEXT,
    "ability04" TEXT,
    "ability05" TEXT,
    "description" TEXT,
PRIMARY KEY("id"),
FOREIGN KEY("set_id") REFERENCES "card_set"("id")
);

CREATE TABLE "card_keywords" (
    "card_id" TEXT,
    "keyword" TEXT,
FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

CREATE TABLE "card_set" (
    "id" INTEGER,
    "place_id" INTEGER,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "boosterpack_cost" INTEGER NOT NULL,
PRIMARY KEY("id"),
FOREIGN KEY("place_id") REFERENCES "places"("id")
);

--Tables related to Game World

Create Table "places" (
    "id" INTEGER,
    "type" TEXT NOT NULL,
    "region_id",
    "description" TEXT NOT NULL,
PRIMARY KEY("id"),
FOREIGN KEY("region_id") REFERENCES "places"("id")
);

Create TABLE "game_texts" (
    "id" INTEGER,
    "type" TEXT NOT NULL,
    "part" INTEGER,
    "chapter" INTEGER,
    "character_id" INTEGER,
    "quest_id" INTEGER,
    "previous_text_id" INTEGER,
    "next_text_id" INTEGER,
    "text" TEXT NOT NULL,
PRIMARY KEY("id"),
FOREIGN KEY("quest_id") REFERENCES "quests"("id"),
FOREIGN KEY("previous_text_id") REFERENCES "game_texts"("id"),
FOREIGN KEY("next_text_id") REFERENCES "game_texts"("id")
);

CREATE TABLE "quests" (
    "id" INTEGER,
    "type" TEXT NOT NULL,
    "part" INTEGER,
    "chapter" INTEGER,
    "parent_id" INTEGER,
    "previous_quest_id" INTEGER,
    "next_quest_id" INTEGER,
    "character_id" INTEGER,
    "place_id" INTEGER,
    "text" TEXT NOT NULL,
PRIMARY KEY("id"),
FOREIGN KEY("parent_id") REFERENCES "quests"("id"),
FOREIGN KEY("previous_quest_id") REFERENCES "quests"("id"),
FOREIGN KEY("next_quest_id") REFERENCES "quests"("id"),
FOREIGN KEY("place_id") REFERENCES "places"("id")
);

CREATE TABLE "items" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "item_type" TEXT NOT NULL,
    "cost" INTEGER,
    "item_slot" TEXT,
    "item_limit" INTEGER NOT NULL CHECK ("item_limit" > 0),
    "description" TEXT NOT NULL,
PRIMARY KEY("id")
);

-- Tables related to characters

CREATE TABLE "characters" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "faction" TEXT,
    "enemy_id" INTEGER,
    "seller_id" INTEGER,
    "version" INTEGER NOT NULL,
    "place_id" INTEGER,
    "description" TEXT NOT NULL,
PRIMARY KEY("id"),
FOREIGN KEY("place_id") REFERENCES "places"("id")
);

CREATE TABLE "enemies" (
    "character_id" INTEGER,
    "enemy_points" INTEGER,
    "deck_name" TEXT,
    "deck_description" TEXT,
    "booster_pack_id" INTEGER,
    "booster_pack_quantity" INTEGER,
FOREIGN KEY("character_id") REFERENCES "characters"("id"),
FOREIGN KEY("booster_pack_id") REFERENCES "card_set"("id")
);

CREATE TABLE "enemy_card_list" (
    "character_id" INTEGER,
    "card_id" TEXT,
    "card_copies" INTEGER NOT NULL CHECK ("card_copies" BETWEEN 0 and 3),
    FOREIGN KEY("character_id") REFERENCES "characters"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

CREATE TABLE "enemy_card_rewards" (
    "character_id" INTEGER,
    "card_id" TEXT,
    "card_copies" INTEGER NOT NULL CHECK ("card_copies" BETWEEN 0 and 3),
    FOREIGN KEY("character_id") REFERENCES "characters"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

CREATE TABLE "enemy_item_rewards" (
    "item_id" INTEGER,
    "item_copies" INTEGER,
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

CREATE TABLE "sellers_card_list" (
    "character_id" INTEGER,
    "card_id" TEXT,
    "card_copies" INTEGER NOT NULL CHECK ("card_copies" BETWEEN 0 and 3),
    FOREIGN KEY("character_id") REFERENCES "characters"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
   );

CREATE TABLE "sellers_item_list" (
    "item_id" INTEGER,
    "item_copies" INTEGER CHECK ("item_copies" > 0),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

-- Tables related to Players

CREATE TABLE "players" (
    "id" INTEGER CHECK ("id" BETWEEN 0 and 9 ),
    "name" TEXT NOT NULL,
    "battles" INTEGER DEFAULT "0",
    "battles_won" INTEGER DEFAULT "0",
    "battle_lost" INTEGER DEFAULT "0",
    "game_time" INTEGER DEFAULT "0",
PRIMARY KEY("id")
);

CREATE TABLE "player_save_files" (
    "id" INTEGER,
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9 ),
    "name" TEXT,
    "save_file_date" INTEGER,
PRIMARY KEY("id"),
FOREIGN KEY("player_id") REFERENCES "players"("id")
);

CREATE TABLE "player_card_library" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9 ),
    "save_id" INTEGER,
    "card_id" TEXT NOT NULL,
    "card_copies" INTEGER NOT NULL,
    FOREIGN KEY("player_id") REFERENCES "players"("id"),
    FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

CREATE TABLE "player_card_decks" (
    "id" INTEGER,
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9 ),
    "save_id" INTEGER,
    "name" TEXT NOT NULL,
    "date_created" INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" TEXT,
PRIMARY KEY("id"),
FOREIGN KEY("player_id") REFERENCES "players"("id"),
FOREIGN KEY("save_id") REFERENCES "player_save_files"("id")
);

CREATE TABLE "player_card_list" (
    "deck_id" INTEGER,
    "card_id" TEXT,
    "card_copies" INTEGER NOT NULL,
FOREIGN KEY("deck_id") REFERENCES "player_card_decks"("id"),
FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

CREATE TABLE "player_owned_items" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9),
    "save_id" INTEGER,
    "item_id" INTEGER,
    "item_copies" INTEGER NOT NULL,
FOREIGN KEY("player_id") REFERENCES "players"("id"),
FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
FOREIGN KEY("item_id") REFERENCES "items"("id")
);

CREATE TABLE "player_seller_cards" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9),
    "save_id" INTEGER,
    "card_id" TEXT,
    "card_copies" INTEGER NOT NULL,
FOREIGN KEY("player_id") REFERENCES "players"("id"),
FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
FOREIGN KEY("card_id") REFERENCES "cards"("id")
);

CREATE TABLE "player_seller_items" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9),
    "save_id" INTEGER,
    "character_id" INTEGER,
    "item_id" INTEGER,
    "item_copies" INTEGER NOT NULL,
FOREIGN KEY("player_id") REFERENCES "players"("id"),
FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
FOREIGN KEY("character_id") REFERENCES "characters"("id")
);

CREATE TABLE "player_quests" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9),
    "save_id" INTEGER,
    "quest_id" INTEGER,
FOREIGN KEY("player_id") REFERENCES "players"("id"),
FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
FOREIGN KEY("quest_id") REFERENCES "quests"("id")
);

CREATE TABLE "player_places" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9),
    "save_id" INTEGER,
    "place_id" INTEGER,
    FOREIGN KEY("player_id") REFERENCES "players"("id"),
    FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
    FOREIGN KEY("place_id") REFERENCES "places"("id")
);

CREATE TABLE "player_characters" (
    "player_id" INTEGER CHECK ("player_id" BETWEEN 0 and 9 ),
    "save_id" INTEGER,
    "character_id" INTEGER,
FOREIGN KEY("player_id") REFERENCES "players"("id"),
FOREIGN KEY("save_id") REFERENCES "player_save_files"("id"),
FOREIGN KEY("character_id") REFERENCES "characters"("id")
);

--INDEXES
CREATE INDEX "card_searches" ON "cards" ("name", "set_id","type");
CREATE INDEX "card_keywords_searches" ON "card_keywords" ("keyword");
CREATE INDEX "game_texts_search" ON "game_texts" ("type", "character_id", "quest_id",  "previous_text_id", "next_text_id");
CREATE INDEX "quests_search" ON "quests" ("parent_id", "previous_quest_id", "next_quest_id", "character_id", "place_id");
CREATE INDEX "characters_search" ON "characters" ("name", "enemy_id", "seller_id");
CREATE INDEX "enemy_card_list_search" ON "enemy_card_list" ("card_id");
CREATE INDEX "sellers_card_list_search" ON "sellers_card_list" ("card_id");
CREATE INDEX "player_card_library_search" ON "player_card_library" ("card_id");
CREATE INDEX "player_card_decks_search" ON "player_card_decks" ("player_id", "save_id");
CREATE INDEX "player_card_list_search" on "player_card_list" ("deck_id", "card_id");
CREATE INDEX "player_character_search" on "player_characters" ("player_id", "save_id", "character_id")
