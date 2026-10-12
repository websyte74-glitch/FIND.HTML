alter table public.listings
  add column if not exists user_id uuid references auth.users(id) on delete set null;

alter table public.listings enable row level security;
grant usage on schema public to anon, authenticated;

drop policy if exists "Anyone can post valid UPSA Find listings" on public.listings;
drop policy if exists "Signed-in students can post their own UPSA Find listings" on public.listings;
create policy "Signed-in students can post their own UPSA Find listings"
  on public.listings
  for insert
  to authenticated
  with check (auth.uid() = user_id);

grant select on public.listings to anon, authenticated;
grant insert on public.listings to authenticated;
revoke insert on public.listings from anon;

create or replace function public.require_upsa_email()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.email is null or lower(new.email) not like '%@upsamail.edu.gh' then
    raise exception 'Only UPSA email addresses ending in @upsamail.edu.gh may register.';
  end if;
  return new;
end;
$$;

drop trigger if exists require_upsa_email_on_signup on auth.users;
create trigger require_upsa_email_on_signup
  before insert or update of email on auth.users
  for each row execute function public.require_upsa_email();
