# Generated by Django 4.2.7 on 2023-11-29 12:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("rent", "0001_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="rent",
            name="endedAt",
            field=models.DateTimeField(verbose_name="반납 시간"),
        ),
    ]
