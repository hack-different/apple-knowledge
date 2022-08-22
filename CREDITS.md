# Credits

{% for project in site.data.credits.repositories %}

## {{project[0]}}

{% for credit in project[1].contributors %}

* @{{ credit.login }}{% endfor %}{% endfor %}
