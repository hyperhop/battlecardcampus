-- Create a card set
INSERT INTO "card_set" ("id", "name", "description", "boosterpack_cost")
VALUES
    (1, "Core", "Core set", 2000)
;

-- Create a region and location
INSERT INTO "places"
VALUES
    (1, "Region", NULL, "Campus");
;

INSERT INTO "places"
VALUES
    (2, "Location", 1, "Engineering")
;

-- Select cards from set 1
SELECT "id", "name", "type" from cards where "set_id" = 1;

-- insert cards into card table
INSERT INTO "cards"
Values
    ("CORE001", "Fireball", "1", "Spell", "Common", "500", "0", NULL, "50", NULL, "Deal 50 damage to a creature.", NULL, NULL, NULL, NULL, "A giant flaming fireball"),
    ("CORE002", "Swordsman", "1", "Creature", "Common", "500", "1", "50", "30", "0", "Summon 2 Swordsman.", NULL, NULL, NULL, NULL, "Swordsmen are basic infantry of many armies"),
    ("CORE003", "Guard Tower", "1", "Location", "Common", "500", "0", "100", "20", "20", NULL, NULL, NULL, NULL, NULL, "A simple defensive structure")
;

-- Insert character "Jason Lee" into characters, enemies and sellers tables.
INSERT INTO "characters"
VALUES
    (1, "Jason Lee", "Engineering", 1, 1, 1, 2, "Young engineering student who loves machines and machine cards!")
;

INSERT INTO "enemies"
VALUES
    (1, 100, "Machines Madness", "Deck full of machines and cards that power them up!", 1, 0)
;

INSERT INTO "enemy_card_list"
VALUES
    (1, "CORE001", 3),
    (1, "CORE002", 3),
    (1, "CORE003", 3)
;

INSERT INTO "sellers_card_list"
VALUES
    (1, "CORE001", 3)
;

-- Insert a new player named "John Sun" and create 1 save file for them
INSERT INTO "players" ("id", "name")
VALUES
    (1, "John Sun")
;

INSERT INTO "player_save_files"
VALUES
    (1, 1, "Save File 1", DATETIME('now'))
;

-- Add a new card into a player's card library
INSERT INTO "player_card_library"
VALUES
    (1, 1, "CORE001", 1)
;

-- Update/add a copy of an existing card in a player's card library
UPDATE "player_card_library"
SET "card_copies" = ("card_copies" + 1)
WHERE "player_id" = 1 AND "save_id" = 1 AND "card_id" = "CORE001"
;

-- Select all cards from a player's card library and check their names and types.
SELECT "cards"."id", "cards"."name", "cards"."type" FROM "player_card_library"
INNER JOIN "cards" ON "cards"."id" = "player_card_library"."card_id"
WHERE "player_card_library"."player_id" = 1 AND "player_card_library"."save_id" = 1
;




