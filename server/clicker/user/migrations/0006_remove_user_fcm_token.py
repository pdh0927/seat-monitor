# Generated by Django 4.2.7 on 2024-05-16 11:05

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("user", "0005_user_fcm_token"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="user",
            name="fcm_token",
        ),
    ]
