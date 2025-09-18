How to measure performance of the video's banner [thumbnail + title]?

After the change in either occurs, the audience feedback is measured by:
- clicks / views (CTR)
- videosAddedToPlaylists

- dislikes ?
views -> engagedViews

Table users {
  id integer [primary key]
  username varchar
  group varchar
  created_at timestamp
}

Table experiments {
  id integer [primary key]
  title varchar
  thumbnail varchar
  clicks integer
  views integer
  to_playlist_count integer
  likes integer
  dislikes integer
  channel_id integer
  user_id integer
  is_active bool
}

Ref user_experiments: experiments.user_id > users.id // many-to-one

experiment = rolling out a changed banner

experiment -> video -> channel -> user

campaign attr:
campaign_start_ts
campaign_end_ts
experiment_start_ts
experiment_end_ts
experiment_id

'abcde'


|---> ---->|
begin     end


system:

        ____(p eps)___
        |             \
    (3) L             |
+ controller - (2) -> create live feedback supervisor
\           \
 \ (0)       \ (1)
  \ - changer (swaps state of the video to new banner)

