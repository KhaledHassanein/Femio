import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ payload }: MigrateUpArgs): Promise<void> {
  // INTENTIONALLY EMPTY.
  //
  // This schema predates migrations: it was created by Payload's dev-time
  // `push` (ADR-018), so every table, type and index in the accompanying
  // snapshot already exists in the database. Running the generated DDL would
  // fail on the first `CREATE TYPE` — verified: `type "_locales" already
  // exists`.
  //
  // The migration still earns its place: its `.json` snapshot is the baseline
  // every future `migrate:create` diffs against, which is what makes the next
  // change a small, reviewable delta instead of a full-schema dump. Recording
  // it as applied is the point; applying it is not.
  payload.logger.info("baseline: schema pre-exists (created by push) — nothing to apply");
}

export async function down({ payload }: MigrateDownArgs): Promise<void> {
  // Nothing to undo; this migration never changed anything.
  payload.logger.info("baseline: nothing to roll back");
}
