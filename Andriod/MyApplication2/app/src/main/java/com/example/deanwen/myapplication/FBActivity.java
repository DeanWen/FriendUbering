package com.example.deanwen.myapplication;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import com.victorsima.uber.UberClient;

import retrofit.RestAdapter;


public class FBActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fb);


    }

    public void callUber(View view) {
        //call uber
        UberClient client = new UberClient("4XTTTGqI9Ncyq4MsbDP8eHbLFg7oXkNF", "SfxjExwdrL67dhoOwFAajxrL1mos3Yen0faf2eLV", "http://localhost", RestAdapter.LogLevel.BASIC);
        System.out.println(client.getApiService().getMe().getFirstName());
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_fb, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
