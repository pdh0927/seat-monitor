# Generated by Django 4.2.7 on 2023-11-17 00:58

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Room",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=20, verbose_name="열람실명")),
                ("total_seat", models.IntegerField(verbose_name="총 좌석수")),
            ],
        ),
    ]
