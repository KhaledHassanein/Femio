import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
   CREATE TABLE "payload"."articles_rels" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"order" integer,
  	"parent_id" integer NOT NULL,
  	"path" varchar NOT NULL,
  	"people_id" integer
  );
  
  CREATE TABLE "payload"."_articles_v_rels" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"order" integer,
  	"parent_id" integer NOT NULL,
  	"path" varchar NOT NULL,
  	"people_id" integer
  );
  
  CREATE TABLE "payload"."conditions_rels" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"order" integer,
  	"parent_id" integer NOT NULL,
  	"path" varchar NOT NULL,
  	"people_id" integer
  );
  
  CREATE TABLE "payload"."_conditions_v_rels" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"order" integer,
  	"parent_id" integer NOT NULL,
  	"path" varchar NOT NULL,
  	"people_id" integer
  );
  
  ALTER TABLE "payload"."articles" ADD COLUMN "medical_reviewer_profile_id" integer;
  ALTER TABLE "payload"."articles" ADD COLUMN "first_published_at" timestamp(3) with time zone;
  ALTER TABLE "payload"."articles" ADD COLUMN "seo_canonical_override" varchar;
  ALTER TABLE "payload"."articles" ADD COLUMN "seo_no_index" boolean DEFAULT false;
  ALTER TABLE "payload"."articles" ADD COLUMN "seo_social_image_id" integer;
  ALTER TABLE "payload"."articles_locales" ADD COLUMN "seo_seo_title" varchar;
  ALTER TABLE "payload"."articles_locales" ADD COLUMN "seo_meta_description" varchar;
  ALTER TABLE "payload"."articles_locales" ADD COLUMN "seo_social_title" varchar;
  ALTER TABLE "payload"."articles_locales" ADD COLUMN "seo_social_description" varchar;
  ALTER TABLE "payload"."_articles_v" ADD COLUMN "version_medical_reviewer_profile_id" integer;
  ALTER TABLE "payload"."_articles_v" ADD COLUMN "version_first_published_at" timestamp(3) with time zone;
  ALTER TABLE "payload"."_articles_v" ADD COLUMN "version_seo_canonical_override" varchar;
  ALTER TABLE "payload"."_articles_v" ADD COLUMN "version_seo_no_index" boolean DEFAULT false;
  ALTER TABLE "payload"."_articles_v" ADD COLUMN "version_seo_social_image_id" integer;
  ALTER TABLE "payload"."_articles_v_locales" ADD COLUMN "version_seo_seo_title" varchar;
  ALTER TABLE "payload"."_articles_v_locales" ADD COLUMN "version_seo_meta_description" varchar;
  ALTER TABLE "payload"."_articles_v_locales" ADD COLUMN "version_seo_social_title" varchar;
  ALTER TABLE "payload"."_articles_v_locales" ADD COLUMN "version_seo_social_description" varchar;
  ALTER TABLE "payload"."conditions" ADD COLUMN "medical_reviewer_profile_id" integer;
  ALTER TABLE "payload"."conditions" ADD COLUMN "first_published_at" timestamp(3) with time zone;
  ALTER TABLE "payload"."conditions" ADD COLUMN "seo_canonical_override" varchar;
  ALTER TABLE "payload"."conditions" ADD COLUMN "seo_no_index" boolean DEFAULT false;
  ALTER TABLE "payload"."conditions" ADD COLUMN "seo_social_image_id" integer;
  ALTER TABLE "payload"."conditions_locales" ADD COLUMN "seo_seo_title" varchar;
  ALTER TABLE "payload"."conditions_locales" ADD COLUMN "seo_meta_description" varchar;
  ALTER TABLE "payload"."conditions_locales" ADD COLUMN "seo_social_title" varchar;
  ALTER TABLE "payload"."conditions_locales" ADD COLUMN "seo_social_description" varchar;
  ALTER TABLE "payload"."_conditions_v" ADD COLUMN "version_medical_reviewer_profile_id" integer;
  ALTER TABLE "payload"."_conditions_v" ADD COLUMN "version_first_published_at" timestamp(3) with time zone;
  ALTER TABLE "payload"."_conditions_v" ADD COLUMN "version_seo_canonical_override" varchar;
  ALTER TABLE "payload"."_conditions_v" ADD COLUMN "version_seo_no_index" boolean DEFAULT false;
  ALTER TABLE "payload"."_conditions_v" ADD COLUMN "version_seo_social_image_id" integer;
  ALTER TABLE "payload"."_conditions_v_locales" ADD COLUMN "version_seo_seo_title" varchar;
  ALTER TABLE "payload"."_conditions_v_locales" ADD COLUMN "version_seo_meta_description" varchar;
  ALTER TABLE "payload"."_conditions_v_locales" ADD COLUMN "version_seo_social_title" varchar;
  ALTER TABLE "payload"."_conditions_v_locales" ADD COLUMN "version_seo_social_description" varchar;
  ALTER TABLE "payload"."articles_rels" ADD CONSTRAINT "articles_rels_parent_fk" FOREIGN KEY ("parent_id") REFERENCES "payload"."articles"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."articles_rels" ADD CONSTRAINT "articles_rels_people_fk" FOREIGN KEY ("people_id") REFERENCES "payload"."people"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."_articles_v_rels" ADD CONSTRAINT "_articles_v_rels_parent_fk" FOREIGN KEY ("parent_id") REFERENCES "payload"."_articles_v"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."_articles_v_rels" ADD CONSTRAINT "_articles_v_rels_people_fk" FOREIGN KEY ("people_id") REFERENCES "payload"."people"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."conditions_rels" ADD CONSTRAINT "conditions_rels_parent_fk" FOREIGN KEY ("parent_id") REFERENCES "payload"."conditions"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."conditions_rels" ADD CONSTRAINT "conditions_rels_people_fk" FOREIGN KEY ("people_id") REFERENCES "payload"."people"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."_conditions_v_rels" ADD CONSTRAINT "_conditions_v_rels_parent_fk" FOREIGN KEY ("parent_id") REFERENCES "payload"."_conditions_v"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "payload"."_conditions_v_rels" ADD CONSTRAINT "_conditions_v_rels_people_fk" FOREIGN KEY ("people_id") REFERENCES "payload"."people"("id") ON DELETE cascade ON UPDATE no action;
  CREATE INDEX "articles_rels_order_idx" ON "payload"."articles_rels" USING btree ("order");
  CREATE INDEX "articles_rels_parent_idx" ON "payload"."articles_rels" USING btree ("parent_id");
  CREATE INDEX "articles_rels_path_idx" ON "payload"."articles_rels" USING btree ("path");
  CREATE INDEX "articles_rels_people_id_idx" ON "payload"."articles_rels" USING btree ("people_id");
  CREATE INDEX "_articles_v_rels_order_idx" ON "payload"."_articles_v_rels" USING btree ("order");
  CREATE INDEX "_articles_v_rels_parent_idx" ON "payload"."_articles_v_rels" USING btree ("parent_id");
  CREATE INDEX "_articles_v_rels_path_idx" ON "payload"."_articles_v_rels" USING btree ("path");
  CREATE INDEX "_articles_v_rels_people_id_idx" ON "payload"."_articles_v_rels" USING btree ("people_id");
  CREATE INDEX "conditions_rels_order_idx" ON "payload"."conditions_rels" USING btree ("order");
  CREATE INDEX "conditions_rels_parent_idx" ON "payload"."conditions_rels" USING btree ("parent_id");
  CREATE INDEX "conditions_rels_path_idx" ON "payload"."conditions_rels" USING btree ("path");
  CREATE INDEX "conditions_rels_people_id_idx" ON "payload"."conditions_rels" USING btree ("people_id");
  CREATE INDEX "_conditions_v_rels_order_idx" ON "payload"."_conditions_v_rels" USING btree ("order");
  CREATE INDEX "_conditions_v_rels_parent_idx" ON "payload"."_conditions_v_rels" USING btree ("parent_id");
  CREATE INDEX "_conditions_v_rels_path_idx" ON "payload"."_conditions_v_rels" USING btree ("path");
  CREATE INDEX "_conditions_v_rels_people_id_idx" ON "payload"."_conditions_v_rels" USING btree ("people_id");
  ALTER TABLE "payload"."articles" ADD CONSTRAINT "articles_medical_reviewer_profile_id_people_id_fk" FOREIGN KEY ("medical_reviewer_profile_id") REFERENCES "payload"."people"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."articles" ADD CONSTRAINT "articles_seo_social_image_id_media_id_fk" FOREIGN KEY ("seo_social_image_id") REFERENCES "payload"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."_articles_v" ADD CONSTRAINT "_articles_v_version_medical_reviewer_profile_id_people_id_fk" FOREIGN KEY ("version_medical_reviewer_profile_id") REFERENCES "payload"."people"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."_articles_v" ADD CONSTRAINT "_articles_v_version_seo_social_image_id_media_id_fk" FOREIGN KEY ("version_seo_social_image_id") REFERENCES "payload"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."conditions" ADD CONSTRAINT "conditions_medical_reviewer_profile_id_people_id_fk" FOREIGN KEY ("medical_reviewer_profile_id") REFERENCES "payload"."people"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."conditions" ADD CONSTRAINT "conditions_seo_social_image_id_media_id_fk" FOREIGN KEY ("seo_social_image_id") REFERENCES "payload"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."_conditions_v" ADD CONSTRAINT "_conditions_v_version_medical_reviewer_profile_id_people_id_fk" FOREIGN KEY ("version_medical_reviewer_profile_id") REFERENCES "payload"."people"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "payload"."_conditions_v" ADD CONSTRAINT "_conditions_v_version_seo_social_image_id_media_id_fk" FOREIGN KEY ("version_seo_social_image_id") REFERENCES "payload"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "articles_medical_reviewer_profile_idx" ON "payload"."articles" USING btree ("medical_reviewer_profile_id");
  CREATE INDEX "articles_seo_seo_social_image_idx" ON "payload"."articles" USING btree ("seo_social_image_id");
  CREATE INDEX "_articles_v_version_version_medical_reviewer_profile_idx" ON "payload"."_articles_v" USING btree ("version_medical_reviewer_profile_id");
  CREATE INDEX "_articles_v_version_seo_version_seo_social_image_idx" ON "payload"."_articles_v" USING btree ("version_seo_social_image_id");
  CREATE INDEX "conditions_medical_reviewer_profile_idx" ON "payload"."conditions" USING btree ("medical_reviewer_profile_id");
  CREATE INDEX "conditions_seo_seo_social_image_idx" ON "payload"."conditions" USING btree ("seo_social_image_id");
  CREATE INDEX "_conditions_v_version_version_medical_reviewer_profile_idx" ON "payload"."_conditions_v" USING btree ("version_medical_reviewer_profile_id");
  CREATE INDEX "_conditions_v_version_seo_version_seo_social_image_idx" ON "payload"."_conditions_v" USING btree ("version_seo_social_image_id");`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "payload"."articles_rels" DISABLE ROW LEVEL SECURITY;
  ALTER TABLE "payload"."_articles_v_rels" DISABLE ROW LEVEL SECURITY;
  ALTER TABLE "payload"."conditions_rels" DISABLE ROW LEVEL SECURITY;
  ALTER TABLE "payload"."_conditions_v_rels" DISABLE ROW LEVEL SECURITY;
  DROP TABLE "payload"."articles_rels" CASCADE;
  DROP TABLE "payload"."_articles_v_rels" CASCADE;
  DROP TABLE "payload"."conditions_rels" CASCADE;
  DROP TABLE "payload"."_conditions_v_rels" CASCADE;
  ALTER TABLE "payload"."articles" DROP CONSTRAINT "articles_medical_reviewer_profile_id_people_id_fk";
  
  ALTER TABLE "payload"."articles" DROP CONSTRAINT "articles_seo_social_image_id_media_id_fk";
  
  ALTER TABLE "payload"."_articles_v" DROP CONSTRAINT "_articles_v_version_medical_reviewer_profile_id_people_id_fk";
  
  ALTER TABLE "payload"."_articles_v" DROP CONSTRAINT "_articles_v_version_seo_social_image_id_media_id_fk";
  
  ALTER TABLE "payload"."conditions" DROP CONSTRAINT "conditions_medical_reviewer_profile_id_people_id_fk";
  
  ALTER TABLE "payload"."conditions" DROP CONSTRAINT "conditions_seo_social_image_id_media_id_fk";
  
  ALTER TABLE "payload"."_conditions_v" DROP CONSTRAINT "_conditions_v_version_medical_reviewer_profile_id_people_id_fk";
  
  ALTER TABLE "payload"."_conditions_v" DROP CONSTRAINT "_conditions_v_version_seo_social_image_id_media_id_fk";
  
  DROP INDEX "payload"."articles_medical_reviewer_profile_idx";
  DROP INDEX "payload"."articles_seo_seo_social_image_idx";
  DROP INDEX "payload"."_articles_v_version_version_medical_reviewer_profile_idx";
  DROP INDEX "payload"."_articles_v_version_seo_version_seo_social_image_idx";
  DROP INDEX "payload"."conditions_medical_reviewer_profile_idx";
  DROP INDEX "payload"."conditions_seo_seo_social_image_idx";
  DROP INDEX "payload"."_conditions_v_version_version_medical_reviewer_profile_idx";
  DROP INDEX "payload"."_conditions_v_version_seo_version_seo_social_image_idx";
  ALTER TABLE "payload"."articles" DROP COLUMN "medical_reviewer_profile_id";
  ALTER TABLE "payload"."articles" DROP COLUMN "first_published_at";
  ALTER TABLE "payload"."articles" DROP COLUMN "seo_canonical_override";
  ALTER TABLE "payload"."articles" DROP COLUMN "seo_no_index";
  ALTER TABLE "payload"."articles" DROP COLUMN "seo_social_image_id";
  ALTER TABLE "payload"."articles_locales" DROP COLUMN "seo_seo_title";
  ALTER TABLE "payload"."articles_locales" DROP COLUMN "seo_meta_description";
  ALTER TABLE "payload"."articles_locales" DROP COLUMN "seo_social_title";
  ALTER TABLE "payload"."articles_locales" DROP COLUMN "seo_social_description";
  ALTER TABLE "payload"."_articles_v" DROP COLUMN "version_medical_reviewer_profile_id";
  ALTER TABLE "payload"."_articles_v" DROP COLUMN "version_first_published_at";
  ALTER TABLE "payload"."_articles_v" DROP COLUMN "version_seo_canonical_override";
  ALTER TABLE "payload"."_articles_v" DROP COLUMN "version_seo_no_index";
  ALTER TABLE "payload"."_articles_v" DROP COLUMN "version_seo_social_image_id";
  ALTER TABLE "payload"."_articles_v_locales" DROP COLUMN "version_seo_seo_title";
  ALTER TABLE "payload"."_articles_v_locales" DROP COLUMN "version_seo_meta_description";
  ALTER TABLE "payload"."_articles_v_locales" DROP COLUMN "version_seo_social_title";
  ALTER TABLE "payload"."_articles_v_locales" DROP COLUMN "version_seo_social_description";
  ALTER TABLE "payload"."conditions" DROP COLUMN "medical_reviewer_profile_id";
  ALTER TABLE "payload"."conditions" DROP COLUMN "first_published_at";
  ALTER TABLE "payload"."conditions" DROP COLUMN "seo_canonical_override";
  ALTER TABLE "payload"."conditions" DROP COLUMN "seo_no_index";
  ALTER TABLE "payload"."conditions" DROP COLUMN "seo_social_image_id";
  ALTER TABLE "payload"."conditions_locales" DROP COLUMN "seo_seo_title";
  ALTER TABLE "payload"."conditions_locales" DROP COLUMN "seo_meta_description";
  ALTER TABLE "payload"."conditions_locales" DROP COLUMN "seo_social_title";
  ALTER TABLE "payload"."conditions_locales" DROP COLUMN "seo_social_description";
  ALTER TABLE "payload"."_conditions_v" DROP COLUMN "version_medical_reviewer_profile_id";
  ALTER TABLE "payload"."_conditions_v" DROP COLUMN "version_first_published_at";
  ALTER TABLE "payload"."_conditions_v" DROP COLUMN "version_seo_canonical_override";
  ALTER TABLE "payload"."_conditions_v" DROP COLUMN "version_seo_no_index";
  ALTER TABLE "payload"."_conditions_v" DROP COLUMN "version_seo_social_image_id";
  ALTER TABLE "payload"."_conditions_v_locales" DROP COLUMN "version_seo_seo_title";
  ALTER TABLE "payload"."_conditions_v_locales" DROP COLUMN "version_seo_meta_description";
  ALTER TABLE "payload"."_conditions_v_locales" DROP COLUMN "version_seo_social_title";
  ALTER TABLE "payload"."_conditions_v_locales" DROP COLUMN "version_seo_social_description";`)
}
